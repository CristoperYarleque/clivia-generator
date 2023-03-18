require "httparty"
require "htmlentities"
require "json"
require "terminal-table"
require "colorize"

require_relative "presenter"
require_relative "requester"
require_relative "aditional/custom"

class CliviaGenerator
  include Presenter
  include Requester
  include Custom

  def initialize(filename)
    @filename = filename
    @questions = []
    @score = 0
    @scores = []
  end

  def start
    print_welcome
    action = select_main_menu_action

    until action == "exit"
      case action
      when "random" then random_trivia
      when "scores" then print_scores
      when "custom" then select_custom
      end
      print_welcome
      action = select_main_menu_action
    end
  end

  def random_trivia(option = "")
    if load_questions(option).empty?
      puts "questions not found, try other options\n".red
    else
      load_questions(option).each do |question|
        select_answer = ask_question(question, parse_questions)
        ask_questions(select_answer, question)
      end
      will_save?(@score)
    end
  end

  def ask_questions(select_answer, question)
    answer_correct = question[:correct_answer]
    if select_answer == answer_correct
      puts "#{parse_questions.decode(select_answer)} ...Correct!\n".blue
      @score += 10
    else
      puts "#{parse_questions.decode(select_answer)} ...Incorrect".red
      puts "The correct answer was: #{parse_questions.decode(answer_correct)}"
      puts ""
    end
  end

  def save(data)
    new_data = @scores << data
    File.write(@filename, new_data.to_json)
    @score = 0
  end

  def parse_scores
    JSON.parse(File.read(@filename), symbolize_names: true)
  rescue Errno::ENOENT => e
    e.class
  end

  def load_questions(option)
    response = HTTParty.get("https://opentdb.com/api.php?amount=10#{option}")
    results = JSON.parse(response.body, symbolize_names: true)

    results[:results]
  end

  def select_custom
    custom_question = questions_category
    random_trivia(custom_question)
  end

  def parse_questions
    HTMLEntities.new
  end

  def print_scores
    data = parse_scores
    if data == Errno::ENOENT
      table_scores([])
    else
      sort_data = data.sort { |x, y| y[:score] <=> x[:score] }
      new_data = sort_data.map { |data_score| [data_score[:name], data_score[:score]] }
      table_scores(new_data)
    end
  end

  def table_scores(data)
    table = Terminal::Table.new
    table.title = "Top Scores".light_blue
    table.headings = ["Name".cyan, "Score".cyan]
    table.rows = data
    puts table
  end
end

file = ARGV.shift
filename = file.nil? ? "scores.json" : file

trivia = CliviaGenerator.new(filename)
trivia.start

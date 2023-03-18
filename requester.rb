module Requester
  def select_main_menu_action
    options = ["random", "custom", "scores", "exit"]
    puts options.join(" | ").green
    gets_option(options)
  end

  def ask_question(question, coder)
    puts "Category: #{question[:category].light_blue} | Difficulty: #{question[:difficulty].light_blue}"
    puts "Question: #{coder.decode(question[:question].light_blue)}"
    options = question[:incorrect_answers].push(question[:correct_answer]).shuffle
    options.each_with_index do |option, i|
      puts "#{i + 1}. #{coder.decode(option).cyan}"
    end
    index = gets_index(options)
    options[index - 1]
  end

  def gets_index(options)
    print "> "
    index_answer = gets.chomp.to_i
    until index_answer <= options.size && index_answer.positive?
      puts "Invalid option"
      print "> "
      index_answer = gets.chomp.to_i
    end
    index_answer
  end

  def will_save?(score)
    print_score(score)
    print "Do you want to save your score? y/n ".magenta
    options = ["y", "n"]
    action = gets_option(options)
    if action == "y"
      puts "Type the name to assign to the score".magenta
      print "> "
      input = gets.chomp
      name = input.empty? ? "Anonymus" : input.capitalize
      data = { name: name, score: @score }
      save(data)
    else
      @score = 0
    end
  end

  def gets_option(options)
    print "> "
    input = gets.chomp.downcase

    until options.include?(input)
      puts "Invalid option"
      print "> "
      input = gets.chomp.downcase
    end
    input
  end
end

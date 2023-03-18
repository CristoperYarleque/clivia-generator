require_relative "category"

module Custom
  def questions_category
    puts "choose the question category:".light_blue
    category = ["Film", "Music", "Sports", "Geography", "History", "Celebrities"]
    print_custom(category)
    index = gets_index(category)
    puts ""
    selection_category = category[index - 1].downcase
    category = Categories::CATEGORIES.select { |name| name[:name] == selection_category }
    selected_category = category[0][:identificador]
    questions_difficulty(selected_category)
  end

  def questions_difficulty(selected_category)
    puts "choose the question difficulty:".light_blue
    difficulty = ["Easy", "Medium", "Hard"]
    print_custom(difficulty)
    index = gets_index(difficulty)
    puts ""
    selected_difficulty = difficulty[index - 1].downcase
    question_type(selected_category, selected_difficulty)
  end

  def question_type(selected_category, selected_difficulty)
    puts "choose the type of question:".light_blue
    type = ["Multiple", "True / False"]
    print_custom(type)
    index = gets_index(type)
    puts ""
    selected_type = type[index - 1] == "True / False" ? "boolean" : "multiple"
    "&category=#{selected_category}&difficulty=#{selected_difficulty}&type=#{selected_type}"
  end

  def print_custom(options)
    options.each_with_index do |option, i|
      puts "#{i + 1}. #{option.cyan}"
    end
  end
end

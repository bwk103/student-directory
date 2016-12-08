require 'csv'
@students = []
@poss_cohorts = ["january", "february", "march", "april", "may", "june",
          "july", "august", "september", "october", "november", "december"]


## START MENU

def start
  puts
  welcome = "Welcome to the Villains Academy Student Directory"
  puts welcome
  puts "-" * welcome.length
  interactive_menu
end

## DISPLAY MENU

def interactive_menu
  try_load_students
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def process(selection)
  case selection
    when "1"
      input_students
    when "2"
      show_students
    when "3"
      print_one_student
    when "4"
      search_by_letter
    when "5"
      search_by_length
    when "6"
      search_by_cohort
    when "7"
      save_students
    when "8"
      filename = load_info
      load_students(filename)
    when "9"
      exit
    else
      puts "I don't know what you meant, try again"
  end
end

def print_menu
  menu_string = "Please select one of the following options:"
  puts "-" * menu_string.length
  puts "Please select one of the following options:"
  puts
  puts "1. Input the students"
  puts "2. Display all students"
  puts "3. Show full information for individual student"
  puts "4. Search students by name"
  puts "5. Search students by length of name"
  puts "6. Search students by cohort"
  puts "7. Save a list"
  puts "8. Load a list"
  puts "9. Exit"
end

 ### INPUTTING STUDENT INFORMATION

def input_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"
  name = STDIN.gets.delete("\n")
  while !name.empty? do
    cohort = get_cohort_from_user(name)
    hobbies = add_student_info(name, "hobbies")
    country = add_student_info(name, "country of birth")
    height = add_student_info(name, "height")
    adding_students(name, cohort, hobbies, country, height)
    puts
    puts "** #{name} has been added to the list of students **"
    puts
    student_plural
    name = STDIN.gets.delete("\n")
  end
end

def get_cohort_from_user(name)
    puts "Which cohort is #{name} in?"
    cohort = STDIN.gets.downcase.chomp
    if @poss_cohorts.include?(cohort)
      cohort = cohort.to_sym
    elsif cohort == ""
      cohort = :january
    else
      puts "That's not a valid cohort!"
      get_cohort_from_user(name)
    end
end

def add_student_info(name, question)
    puts "Would you like to add #{name}'s #{question}? Y/N"
    choice = STDIN.gets.chomp.upcase
    while choice
      if choice == "Y"
        puts "Please provide #{name}'s #{question}"
        answer = STDIN.gets.chomp.capitalize
        break
      elsif choice == "N"
        break
      else
        puts "I'm sorry, I didn't catch that."
        add_student_info(name, question)
        break
      end
    end
    if choice == "Y" && question == "hobbies"
      return answer.split(",")
    else
    return answer
  end
end

def student_plural
  if @students.length < 1
    puts "You've not added any students"
  elsif @students.length == 1
    puts "Now we have #{@students.count} student enrolled at Villains Academy"
  else
    puts "Now we have #{@students.count} students enrolled at Villains Academy"
  end
end

def adding_students(name, cohort, hobbies="N/A", country="N/A", height="N/A")
  @students << {name: name, cohort: cohort, hobbies: hobbies, country: country, height: height}
end


## DISPLAY LIST OF STUDENTS

def show_students
  print_header
  print_students_list
  print_footer
end

def print_header
  puts ("-" * 13).center(80)
  puts "The students of Villains Academy".center(80)
  puts ("-" * 13).center(80)
end

def print_students_list
  count = 0
  while count != @students.length
    puts "#{count + 1}. #{@students[count][:name]} (#{@students[count][:cohort]})".center(80)
    count += 1
  end
end

def print_footer
  puts "Overall, we have #{@students.count} great students".center(80)
end


## DISPLAY FULL INFO FOR INDIVIDUAL STUDENT

def print_one_student
  if @students.length == 0
    no_students
  else
    print_students_list
    puts
    puts "Please select a student in order to see their full information,"
    puts "including their hobbies, country of birth and height."
    selection = STDIN.gets.chomp.to_i
    idx = selection - 1
    puts
    puts "Student: #{@students[idx][:name]}"
    puts "Cohort: #{@students[idx][:cohort]}"
    if @students[idx][:hobbies].is_a?(Array)
      puts "Hobbies: #{@students[idx][:hobbies].join(", ")}"
    else
      puts "Hobbies: #{@students[idx][:hobbies]}"
    end
    puts "Country of Birth: #{@students[idx][:country]}"
    puts "Height: #{@students[idx][:height]}"
  end
end


## SEARCHING STUDENTS

def search_by_letter
  if @students.length == 0
    no_students
  else
    puts "To search for students by name,"
    puts "please provide the letter that their first name starts with"
    letter = STDIN.gets.delete("\n").upcase
    puts ("The students with names beginning with the letter #{letter} are:").center(80)
    @students.each do |student|
      puts (student[:name]).center(80) if student[:name][0] == letter
    end
  end
end

def search_by_length
  if @students.length == 0
    no_students
  else
    puts "What is the maximum length of characters in the student's name?"
    choice = STDIN.gets.chomp.to_i
    puts
    puts "These are the students whose names are #{choice} characters, or less:"
    puts
    @students.each do |student|
      puts "- " + student[:name] if student[:name].length <= choice
    end
  end
end

def search_by_cohort
  if @students.length == 0
    no_students
  else
    puts "To search for students by cohort, please provide a cohort (month)"
    cohort = STDIN.gets.delete("\n")
    puts "The students in the #{cohort} cohort are:"
    @students.each do |student|
      puts (student[:name]).center(80) if student[:cohort] == cohort
    end
  end
end

def no_students
  puts "There are currently no students in the student list."
  puts "Try adding student details using option '1' or loading a student list"
  puts "using option '7'."
end

## SAVE STUDENT LIST

def save_students
  filename = save_location
  # open the file for writing
  CSV.open(filename, "w") do |csv|
    @students.each do |student|
      student_data = [student[:name], student[:cohort], student[:hobbies].join,
      student[:country], student[:height]]
      csv << student_data
    end
  end
  puts "-- Save complete"
  puts
end

def save_location
  puts "Where would you like to save the file?"
  puts "Please ensure that your file name ends in '.csv'"
  filename = gets.chomp
  if filename[-4..-1] == ".csv"
    return filename
  else
    return filename + ".csv"
  end
end


## LOAD STUDENT LIST

def load_info
  puts "Which file would you like to load?"
  filename = gets.chomp
  if File.exists?(filename)
    filename
  else
    puts "That file doesn't exist - loading 'students'.csv instead...''"
    return "students.csv"
  end
end

def load_students(filename = "students.csv")
    CSV.foreach(filename, "r") do |row|
      name, cohort, hobbies, country, height = row[0], row[1], row[2], row[3], row[4]
      adding_students(name, cohort, hobbies, country, height)
    end
    puts "-- Successfully loaded #{filename}"
end

def try_load_students
  filename = ARGV.first #first argument from the command line
  return if filename.nil? # get out of the metho if it isn't given
  if File.exists?(filename) #if it exists
    load_students(filename)
    puts "-- Loaded #{@students.count} students from #{filename}"
  else # if the file doesn't exist
    puts "Sorry, #{filename} doesn't exist."
    exit
  end
end

start

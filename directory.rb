@students = []

def input_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"

  poss_cohorts = ["january", "february", "march", "april", "may", "june",
            "july", "august", "september", "october", "november", "december"]

  name = gets.delete("\n")

  while !name.empty? do
    puts "And which cohort is #{name} in?"
    cohort = gets.delete("\n")
    if cohort == ""
      cohort = :january
    elsif poss_cohorts.include?(cohort)
      cohort = cohort.to_sym
    else
      puts "I'm sorry, I didn't quite catch that. Which cohort is #{name} in?"
      cohort = gets.delete("\n")
    end
    puts "What are #{name}'s hobbies? (Please list any hobbies, separated with a comma)"
    hobbies = gets.delete("\n")
    puts "Where was #{name} born?"
    country = gets.delete("\n")
    puts "What is #{name}'s height?"
    height = gets.delete("\n")
    @students << {name: name, cohort: cohort, hobbies: [hobbies.split(", ")], country_of_birth: country, height: height}
    if @students.length == 1
      puts "Now we have #{@students.count} student"
    else
      puts "Now we have #{@students.count} students"
    end
    name = gets.delete("\n")
  end
  if @students.length < 1
    puts "You've not provided any students!"
    exit
  end
end

def interactive_menu
  loop do
    print_menu
    process(gets.chomp)
  end
end

def process(selection)
  case selection
    when "1"
      input_students
    when "2"
      show_students
    when "3"
      save_students
    when "9"
      exit
    else
      puts "I don't know what you meant, try again"
  end
end

def print_menu
  puts "1. Input the students"
  puts "2. Display the students"
  puts "3. Save the list to students.csv"
  puts "9. Exit"
end

def show_students
  print_header
  print_students_list
  print_footer
end

def save_students
  # open the file for writing
  file = File.open("students.csv", "w")
  # iterate over the array of students
  @students.each do |student|
    student_data = [student[:name], student[:cohort]]
    csv_line = student_data.join(",")
    file.puts csv_line
  end
  file.close
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

def names_with_specific_letter
  puts "To search for individual students,"
  puts "please provide the first letter of their name"
  letter = gets.delete("\n").upcase
  puts ("The students with names beginning with the letter #{letter} are:").center(80)
  @students.each do |student|
    puts (student[:name]).center(80) if student[:name][0] == letter
  end
end

def print_short_names
  puts "The students with names shorter than 12 characters are:"
  @students.each do |student|
    (puts student[:name] if student[:name].length < 12)
  end
end

def print_footer
  puts "Overall, we have #{@students.count} great students".center(80)
end

def print_by_cohort
  puts "To search for students by cohort, please provide a cohort (month)"
  cohort = gets.delete("\n").to_sym
  @students.each do |student|
    puts (student[:name]).center(80) if student[:cohort] == cohort
  end
end

interactive_menu

def input_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"

  students = []

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
    students << {name: name, cohort: cohort, hobbies: [hobbies.split(", ")], country_of_birth: country, height: height}
    if students.length == 1
      puts "Now we have #{students.count} student"
    else
      puts "Now we have #{students.count} students"
    end
    name = gets.delete("\n")
  end
  if students.length < 1
    puts "You've not provided any students!"
    exit
  else
    students
  end
end

def print_header
  puts ("-" * 13).center(80)
  puts "The students of Villains Academy".center(80)
  puts ("-" * 13).center(80)
end

def print_names(students)
  count = 0
  while count != students.length
    puts "#{count + 1}. #{students[count][:name]} (#{students[count][:cohort]})".center(80)
    count += 1
  end
end

def names_with_specific_letter(students)
  puts "To search for individual students,"
  puts "please provide the first letter of their name"
  letter = gets.delete("\n").upcase
  puts ("The students with names beginning with the letter #{letter} are:").center(80)
  students. each do |student|
    puts (student[:name]).center(80) if student[:name][0] == letter
  end
end

def print_short_names(students)
  puts "The students with names shorter than 12 characters are:"
  students.each do |student|
    (puts student[:name] if student[:name].length < 12)
  end
end

def print_footer(students)
  puts "Overall, we have #{students.count} great students".center(80)
end

def print_by_cohort(students)
  puts "To search for students by cohort, please provide a cohort (month)"
  cohort = gets.delete("\n").to_sym
  students.each do |student|
    puts (student[:name]).center(80) if student[:cohort] == cohort
  end
end

students = input_students
print_header
print_names(students)
puts ""
print_footer(students)
puts
names_with_specific_letter(students)
puts
print_short_names(students)
puts
print_by_cohort(students)
#print_letter(students)
#print_short_names(students)
#print_without_each(students)

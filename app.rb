require './student'
require './teacher'
require './rentals'
require './book'

class App
  def initialize
    @people = []
    @books = []
    @id = 0
  end

  def run
    puts 'Welcome to School Library App!'
    display_options

    task_list = {
      '1' => method(:list_all_books),
      '2' => method(:list_all_people),
      '3' => method(:create_person),
      '4' => method(:create_book),
      '5' => method(:create_rental),
      '6' => method(:list_person_rentals)
    }

    task = gets.chomp
    if task.to_i.positive? && task.to_i < 7
      task_list[task].call
    elsif task == '7'
      puts 'Thank you for using this app!'
    else
      puts 'Please select a valid choice from the list'
      run
    end
  end

  def display_options
    puts 'Please choose an option by entering a number:'
    puts '1 - List all books'
    puts '2 - List all people'
    puts '3 - Create a person'
    puts '4 - Create a book'
    puts '5 - Create a rental'
    puts '6 - List all rentals for a given person id'
    puts '7 - Exit'
  end

  def restart_app
    puts 'Would you like to restart the app? - Y/N'
    key = gets.chomp
    case key
    when 'Y'
      run
    when 'N'
      puts 'Thank you for using this app!'
    else
      puts 'Unknown command'
    end
  end

  def create_person
    print 'Do you want to create a student (1) or a teacher (2)? [Input the number]: '
    person_selected = gets.chomp.strip.to_i

    case person_selected
    when 1
      create_student
      @id += 1
    when 2
      create_teacher
      @id += 1
    else
      puts 'Invalid Selection. Returning to main menu'
      nil
    end
  end

  def create_student
    print 'Age: '
    age = gets.chomp.to_i
    print 'Name: '
    name = gets.chomp.strip.capitalize
    print 'Has Parent Permission? [Y/N]: '
    permission = gets.chomp.strip.upcase
    case permission
    when 'Y', 'YES'
      permission = true
    when 'N', 'NO'
      permission = false
    else
      puts 'Wrong input for permission'
      @id -= 1
      return
    end
    student = Student.new(@id, age, nil, name, parent_permission: permission)
    @people << student
    puts 'Person created successfully'
    restart_app
  end

  def create_teacher
    print 'Age: '
    age = gets.chomp.to_i
    if age <= 0
      @id -= 1
      return puts 'Wrong input for age. Returning to main menu'
    end
    print 'Name: '
    name = gets.chomp.strip.capitalize
    print 'Specialization: '
    specialization = gets.chomp.strip.capitalize
    teacher = Teacher.new(@id, age, specialization, name)
    @people << teacher
    puts 'Person created successfully'
    restart_app
  end

  def create_book
    print 'Title: '
    title = gets.chomp.strip.capitalize
    print 'Author: '
    author = gets.chomp.strip.capitalize
    book = Book.new(title, author)
    @books << book
    puts 'Book created successfully'
    restart_app
  end

  def list_all_people
    @people.each_with_index do |person, index|
      puts "#{index}) [#{person.class.name}] Name: #{person.name}, ID: #{person.id}, Age: #{person.age}"
      restart_app
    end
  end

  def list_all_books
    @books.each_with_index { |book, index| puts %{#{index}) Title: \"#{book.title}"\, Author: #{book.author}} }
    restart_app
  end

  def create_rental
    puts 'Select a book from the following list by number'
    list_all_books
    book_selected = gets.chomp.to_i
    puts 'Select a person from the following list by number (not id)'
    list_all_people
    person_selected = gets.chomp.to_i
    puts
    print 'Date (YYYY/MM/DD) : '
    date = gets.chomp.strip
    Rental.new(date, @books[book_selected], @people[person_selected])
    puts 'Rental created successfully'
    restart_app
  end

  def list_person_rentals
    print 'ID of person: '
    id = gets.chomp.to_i
    puts 'Rentals: '
    @people.each do |person|
      next unless person.id == id

      person.rentals.each do |rental|
        puts %(Date: #{rental.date}, Book \"#{rental.book.title}\" by #{rental.book.author})
        restart_app
      end
    end
  end
end

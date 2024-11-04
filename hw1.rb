class DuplicateStudentError < StandardError
  def initialize
    super('This student already exists.')
  end
end

class Student
  attr_accessor :surname, :name, :date_of_birth

  @@students = []

  def initialize(surname, name, date_of_birth)
    raise ArgumentError, 'Date of birth must be in the past' if Date.parse(date_of_birth) > Date.today

    @surname = surname
    @name = name
    @date_of_birth = Date.parse(date_of_birth)
    add_student
  end

  def self.students
    @@students
  end

  def calculate_age
    today = Date.today
    age = today.year - date_of_birth.year
    if (date_of_birth.month > today.month) || (date_of_birth.month == today.month && date_of_birth.day > today.day)
      age -= 1
    end
    age
  end

  def add_student
    if self.class.students.any? { |s| s.name == name && s.surname == surname && s.date_of_birth == date_of_birth }
      raise DuplicateStudentError
    end
    self.class.students << self
  end

  def remove_student
    self.class.students.delete(self)
  end

  def self.get_students_by_age(age)
    @@students.select { |student| student.calculate_age == age }
  end

  def self.get_students_by_name(name)
    @@students.select { |student| student.name == name }
  end
end
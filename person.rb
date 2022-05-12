require './nameable'
require './rentals'

class Person < Nameable
  attr_reader :id, :rentals
  attr_accessor :name, :age

  def initialize(id, age, name = 'Unknown', parent_permission: true)
    super()
    @id = id
    @name = name
    @age = age
    @parent_permission = parent_permission
    @rentals = []
  end

  def can_use_services?
    @parent_permission || of_age?
  end

  def correct_name
    @name
  end

  def add_rental(date, person)
    Rental.new(date, self, person)
  end

  private

  def of_age?
    @age >= 18
  end
end

class Person
  attr_reader :id
  attr_accessor :name, :age

  def initialize(id, name, age = 'Unknown', parent_permission: true)
    @id = id
    @name = name
    @age = age
    @parent_permission = parent_permission
  end

  def can_use_services?
    @parent_permission || is_of_age?
  end

  private

  def is_of_age?
    @age>= 18
  end
end
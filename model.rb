class Model
  attr_reader :id

  def initialize(attributes)
    attributes.each { |key, value| instance_variable_set("@#{key}", value) }
  end
end
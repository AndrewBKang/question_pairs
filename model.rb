class Model
  def initialize(attributes)
    attributes.each { |key, value| instance_variable_set("@#{key}", value) }
  end
end
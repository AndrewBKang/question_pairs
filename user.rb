require_relative 'questions_database'

class User

  attr_accessor :id

  def self.db
    QuestionsDatabase.instance
  end

  def self.find_by_name(fname, lname)
    query = <<-SQL
      SELECT id
      FROM users
      WHERE users.fname = fname
      AND users.lname = lname
    SQL
    self.db.execute(query).first["id"]
  end

  def initialize(fname, lname)
    id
  end
end
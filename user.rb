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
      WHERE users.fname = ?
      AND users.lname = ?
    SQL
    self.new(self.db.execute(query,fname,lname).first["id"])
  end

  def initialize(id)
    self.id = id
  end

  def authored_questions
    query = <<-SQL
      SELECT id
      FROM questions
      WHERE questions.author_id = ?
    SQL

    self.class.db.execute(query, id).map { |hash| hash.values}.flatten
  end

  def authored_replies
    query = <<-SQL
      SELECT id
      FROM replies
      WHERE replies.author_id = ?
    SQL

    self.class.db.execute(query, id).map { |hash| hash.values}.flatten
  end
end
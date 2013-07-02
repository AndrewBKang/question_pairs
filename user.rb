require_relative 'questions_database'

class User

  attr_reader :id

  def self.find_by_name(fname, lname)
    query = <<-SQL
      SELECT id
      FROM users
      WHERE users.fname = ?
      AND users.lname = ?
    SQL
    self.new(QuestionsDatabase.instance.execute(query,fname,lname).first["id"])
  end

  def initialize(id)
    @id = id
  end

  def authored_questions
    Question.find_by_author_id(@id)
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
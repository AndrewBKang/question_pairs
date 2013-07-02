require_relative 'questions_database'
require_relative 'model'
require_relative 'question'
require_relative 'reply'

class User < Model

  attr_reader :id, :fname, :lname

  def self.find_by_name(fname, lname)
    query = <<-SQL
      SELECT *
      FROM users
      WHERE users.fname = ?
      AND users.lname = ?
    SQL
    self.new(QuestionsDatabase.instance.execute(query,fname,lname).first)
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    query = <<-SQL
      SELECT *
      FROM replies
      WHERE replies.author_id = ?
    SQL

    QuestionsDatabase.instance.execute(query, id).
    map { |hash| Reply.new(hash) }
  end
end
require_relative 'questions_database'
require_relative 'user'
require_relative 'model'

class Question < Model

  attr_reader :id

  def self.find_by_author_id(id)
    query = <<-SQL
      SELECT *
      FROM questions
      WHERE questions.author_id = ?
    SQL
    QuestionsDatabase.instance.execute(query,id).
    map { |hash| self.new(hash) }
  end

  def author
    query = <<-SQL
      SELECT users.id, users.fname, users.lname
      FROM questions
      JOIN users ON questions.author_id = users.id
      WHERE questions.id = ?
    SQL

    User.new(QuestionsDatabase.instance.execute(query, @id).first)
  end

  def replies
    query = <<-SQL
      SELECT *
      FROM replies
      WHERE replies.question_id = ?
    SQL

    QuestionsDatabase.instance.execute(query, @id).
    map{ |hash| Reply.new(hash) }
  end
end
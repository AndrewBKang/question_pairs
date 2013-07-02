require_relative 'questions_database'
require_relative 'model'

class Reply < Model

  def self.find_by_question_id(id)
    query = <<-SQL
      SELECT *
      FROM replies
      WHERE replies.question_id = ?
    SQL
    QuestionsDatabase.instance.execute(query,id).
    map { |hash| self.new(hash) }
  end

  def self.find_by_user_id(id)
    query = <<-SQL
      SELECT *
      FROM replies
      WHERE replies.author_id = ?
    SQL
    QuestionsDatabase.instance.execute(query,id).
    map { |hash| self.new(hash) }

  end

  def author
    query = <<-SQL
      SELECT users.id, users.fname, users.lname
      FROM replies
      JOIN users ON replies.author_id = users.id
      WHERE replies.id = ?
    SQL

    User.new(
      QuestionsDatabase.instance.
      execute(query, @id).first)
  end

  def question
    query = <<-SQL
      SELECT questions.id, questions.title, questions.body, questions.author_id
      FROM replies
      JOIN questions ON questions.id = replies.question_id
      WHERE replies.id = ?
    SQL

    QuestionsDatabase.instance.execute(query, @id).
    map{ |hash| Question.new(hash) }
  end

  def parent_reply
    query = <<-SQL
      SELECT *
      FROM replies
      WHERE replies.id = ?
    SQL

    hash = QuestionsDatabase.instance.
      execute(query, @id).first

    hash["parent_id"].nil? ? nil : self.new(hash)
  end

  def child_replies
    query = <<-SQL
      SELECT *
      FROM replies
      WHERE replies.parent_id = ?
    SQL

    QuestionsDatabase.instance.execute(query, @id).
    map{ |hash| self.new(hash) }
  end


end

require_relative 'questions_database'

class Reply

  def self.find_by_question_id(id)
    query = <<-SQL
      SELECT id
      FROM replies
      WHERE replies.question_id = ?
    SQL
    QuestionsDatabase.instance.execute(query,id).
    map { |hash| self.new(hash["id"]) }
  end

  def self.find_by_user_id(id)
    query = <<-SQL
      SELECT id
      FROM replies
      WHERE replies.author_id = ?
    SQL
    QuestionsDatabase.instance.execute(query,id).
    map { |hash| self.new(hash["id"]) }

  end

  def initialize(id)
    @id = id
  end

  def author
    query = <<-SQL
      SELECT author_id
      FROM replies
      WHERE replies.id = ?
    SQL

    User.new(
      QuestionsDatabase.instance.
      execute(query, @id).first["author_id"])
  end

  def question
    query = <<-SQL
      SELECT question_id
      FROM replies
      WHERE replies.id = ?
    SQL

    QuestionsDatabase.instance.execute(query, @id).
    map{ |hash| Question.new(hash["question_id"]) }
  end

  def parent_reply
    query = <<-SQL
      SELECT parent_id
      FROM replies
      WHERE replies.id = ?
    SQL

    parent_id = QuestionsDatabase.instance.
      execute(query, @id).first["parent_id"]

    parent_id.nil? ? nil : self.new(parent_id)
  end


end

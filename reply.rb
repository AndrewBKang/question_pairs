require_relative 'questions_database'
require_relative 'model'
require_relative 'sql_helper'

class Reply < Model
  extend SQLHelper

  attr_accessor :reply, :question_id, :parent_id, :author_id

  def self.find_by_question_id(id)
    query = <<-SQL
      SELECT *
      FROM replies
      WHERE replies.question_id = ?
    SQL

    self.run_query(self, query, id)
  end

  def self.find_by_user_id(id)
    query = <<-SQL
      SELECT *
      FROM replies
      WHERE replies.author_id = ?
    SQL

    self.run_query(self, query, id)
  end

  def author
    query = <<-SQL
      SELECT users.id, users.fname, users.lname
      FROM replies
      JOIN users ON replies.author_id = users.id
      WHERE replies.id = ?
    SQL

    self.class.run_query(User, query, id).first
  end

  def question
    query = <<-SQL
      SELECT questions.id, questions.title, questions.body, questions.author_id
      FROM replies
      JOIN questions ON questions.id = replies.question_id
      WHERE replies.id = ?
    SQL

    self.class.run_query(Question, query, id)
  end

  def parent_reply
    query = <<-SQL
      SELECT *
      FROM replies
      WHERE replies.id = ?
    SQL

    hash = QuestionsDatabase.instance.
      execute(query, @id).first

    hash["parent_id"].nil? ? nil : self.class.new(hash)
  end

  def child_replies
    query = <<-SQL
      SELECT *
      FROM replies
      WHERE replies.parent_id = ?
    SQL

    self.class.run_query(self.class, query, id)
  end

  def save
    super({:reply => reply, :question_id => question_id,
      :parent_id => parent_id, :author_id => author_id})
  end
end

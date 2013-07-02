require_relative 'questions_database'
require_relative 'model'
require_relative 'sql_helper'
require_relative 'user'

class Question < Model
  extend SQLHelper

  attr_reader :title, :body, :author_id

  def self.find_by_author_id(id)
    query = <<-SQL
      SELECT *
      FROM questions
      WHERE questions.author_id = ?
    SQL

    self.run_query(self,query,id)
  end

  def author
    query = <<-SQL
      SELECT users.id, users.fname, users.lname
      FROM questions
      JOIN users ON questions.author_id = users.id
      WHERE questions.id = ?
    SQL

    self.class.run_query(User,query,id).first
  end

  def replies
    query = <<-SQL
      SELECT *
      FROM replies
      WHERE replies.question_id = ?
    SQL

    self.class.run_query(Reply,query,id)
  end

  def followers
    QuestionFollower.followers_for_question_id(id)
  end
end
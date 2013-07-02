require_relative 'questions_database'
require_relative 'model'
require_relative 'sql_helper'
require_relative 'question'
require_relative 'reply'

class User < Model
  extend SQLHelper

  attr_reader :fname, :lname

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
    Question.find_by_author_id(id)
  end

  def authored_replies
    query = <<-SQL
      SELECT *
      FROM replies
      WHERE replies.author_id = ?
    SQL

    self.class.run_query(Reply, query, id)
  end

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(id)
  end
end
require_relative 'sql_helper'
require_relative 'user'
require_relative 'question'

class QuestionFollower
  extend SQLHelper

  def self.followers_for_question_id(id)
    query = <<-SQL
      SELECT users.id, users.fname, users.lname
      FROM users
      JOIN question_followers ON users.id = question_followers.follower_id
      WHERE question_followers.question_id = ?
    SQL

    self.run_query(User,query,id)
  end

  def self.followed_questions_for_user_id(id)
    query = <<-SQL
      SELECT questions.id, questions.title, questions.body, questions.author_id
      FROM questions
      JOIN question_followers ON questions.id = question_followers.question_id
      WHERE question_followers.follower_id = ?
    SQL

    self.run_query(Question,query,id)
  end
end
require_relative 'questions_database'
require_relative 'sql_helper'
require_relative 'question'

class QuestionLike
  extend SQLHelper

  def self.likers_for_question_id(question_id)
    query = <<-SQL
      SELECT users.id, users.fname, users.lname
      FROM question_likes
      JOIN users ON users.id = question_likes.user_id
      WHERE question_likes.question_id = ?
    SQL

    self.run_query(User,query,question_id)
  end

  def self.num_likes_for_question_id(question_id)
    query = <<-SQL
      SELECT COUNT(*) AS total
      FROM question_likes
      WHERE question_likes.question_id = ?
      GROUP BY question_likes.question_id
    SQL

    hash = QuestionsDatabase.instance.execute(query, question_id).first
    hash.nil? ? 0 : hash["total"]
  end

  def self.liked_questions_for_user_id(user_id)
    query = <<-SQL
      SELECT questions.id, questions.title, questions.body, questions.author_id
      FROM question_likes
      JOIN questions ON questions.id = question_likes.question_id
      WHERE question_likes.user_id = ?
    SQL

    self.run_query(Question, query, user_id)
  end

  def self.most_liked_questions(n)
    query = <<-SQL
      SELECT questions.id, questions.title, questions.body, questions.author_id
      FROM questions
      JOIN question_likes ON questions.id = question_likes.question_id
      GROUP BY questions.id
      ORDER BY COUNT(question_likes.question_id) DESC
    SQL

    QuestionsDatabase.instance.execute(query).
    map { |hash| Question.new(hash) }[0..n-1]
  end
end
require_relative 'questions_database'
require_relative 'model'
require_relative 'user'
require_relative 'question_follower'
require_relative 'question_like'

class Question < Model
  attr_accessor :title, :body, :author_id

  def self.find_by_author_id(id)
    query = <<-SQL
      SELECT *
      FROM questions
      WHERE questions.author_id = ?
    SQL

    self.run_query(self,query,id)
  end

  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
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

  def likers
    QuestionLike.likers_for_question_id(id)
  end

  def num_likers
    QuestionLike.num_likes_for_question_id(id)
  end

  def save
    super({:title => title, :body => body, :author_id => author_id})
  end
end
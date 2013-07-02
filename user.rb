require_relative 'questions_database'
require_relative 'model'
require_relative 'question'
require_relative 'reply'
require_relative 'question_like'

class User < Model
  attr_accessor :fname, :lname

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

  def liked_questions
    QuestionLike.liked_questions_for_user_id(id)
  end

  def average_karma
    query = <<-SQL
      SELECT AVG(likes) AS average
      FROM (SELECT COUNT(*) AS likes
            FROM users
            JOIN questions ON users.id = questions.author_id
            JOIN question_likes ON questions.id = question_likes.question_id
            WHERE users.id = ?
            GROUP BY questions.id)
    SQL

    QuestionsDatabase.instance.execute(query,id).first["average"]
  end

  def save
    super({:fname => fname, :lname => lname})
  end
end
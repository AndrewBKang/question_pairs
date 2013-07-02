require_relative 'questions_database'

class Question

  attr_reader :id

  def self.find_by_author_id(id)
    query = <<-SQL
      SELECT id
      FROM questions
      WHERE questions.author_id = ?
    SQL
    QuestionsDatabase.instance.execute(query,id).
    map { |hash| self.new(hash.values.first) }
  end

  def initialize(id)
    @id = id
  end
end
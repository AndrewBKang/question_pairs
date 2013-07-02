require_relative 'sql_helper'

class Model
  extend SQLHelper

  attr_reader :id

  CLASS_TO_STR = {"User"     => "users",
                  "Question" => "questions",
                  "Reply"    => "replies"}

  def self.find_by_id(id)
    query = <<-SQL
      SELECT *
      FROM #{CLASS_TO_STR[self.name]}
      WHERE #{CLASS_TO_STR[self.name]}.id = ?
    SQL

    self.run_query(self, query, id).first
  end

  def initialize(attributes)
    attributes.each { |key, value| instance_variable_set("@#{key}", value) }
  end

  def save(hash)
    params = hash.values

    if id.nil?
      query = insert(hash)
    else
      query = update(hash)
      params += [id]
    end

    QuestionsDatabase.instance.execute(query, params)
    @id = QuestionsDatabase.instance.last_insert_row_id if id.nil?
  end

  def insert(hash)
    <<-SQL
      INSERT INTO #{CLASS_TO_STR[self.class.name]} (#{hash.keys.join(",")})
        VALUES (#{(["?"]*hash.length).join(",")})
    SQL
  end

  def update(hash)
    <<-SQL
      UPDATE #{CLASS_TO_STR[self.class.name]}
      SET #{hash.keys.map { |key| key.to_s + " = ?" }.join(",")}
      WHERE id = ?
    SQL
  end
end
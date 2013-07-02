class Model
  attr_reader :id

  CLASS_TO_STR = {"User"     => "users",
                  "Question" => "questions",
                  "Reply"    => "replies"}

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
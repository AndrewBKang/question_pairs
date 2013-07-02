module SQLHelper
  def run_query(classname, query, id)
    QuestionsDatabase.instance.execute(query,id).
    map{ |hash| classname.new(hash) }
  end
end
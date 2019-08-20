require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Question
  attr_accessor :id, :title, :body, :user_id

  def self.find_by_id(id)
    #raise "#{self} does not exist" unless self.id 
    query_result = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT               
      *
    FROM
      questions
    WHERE
      questions.id = ?
    SQL
    
    Question.new(query_result.first) 
  end
  
  def self.find_by_author(user_id)
    query_result = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT               
      *
    FROM
      questions
    WHERE
      questions.user_id = ?
    SQL
    
    Question.new(query_result.first)   
  end

  def initialize(options)
    @id = options['id'] 
    @title = options['title']
    @body = options['body'] 
    @user_id= options['user_id']   
  end

  def author 
    User.find_by_id(self.user_id)
  end

  def replies
    Reply.find_by_question_id(self.id)
  end
end


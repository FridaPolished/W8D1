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

class QuestionLike
  attr_accessor :id, :question_id, :user_id

  def self.find_by_id(id)
    #raise "#{self} does not exist" unless self.id 
    query_result = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT               
      *
    FROM
      question_likes
    WHERE
      question_likes.id = ?
    SQL
    
    QuestionLike.new(query_result.first) 
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']      
  end
end
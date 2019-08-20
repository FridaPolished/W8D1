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

class Reply
  attr_accessor :id, :question_id, :user_id, :parent_reply_id, :body

  def self.find_by_id(id)
    #raise "#{self} does not exist" unless self.id 
    query_result = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT               
      *
    FROM
      replies
    WHERE
      replies.id = ?
    SQL
    
    Reply.new(query_result.first) 
  end

  def self.find_by_parent_id(id)
    #raise "#{self} does not exist" unless self.id 
    query_result = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT               
      *
    FROM
      replies
    WHERE
      replies.parent_reply_id = ?
    SQL
    
    query_result.map { |result| Reply.new(result) }
  end

  def self.find_by_user_id(user_id)
        query_result = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT               
      *
    FROM
      replies
    WHERE
      replies.user_id = ?
    SQL
    
    Reply.new(query_result.first) 
  end

   def self.find_by_question_id(question_id)
    query_result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT               
      *
    FROM
      replies
    WHERE
      replies.question_id = ?
    SQL
    query_result.map{ |reply| Reply.new(reply) }
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
    @parent_reply_id = options['parent_reply_id']
    @body = options['body']      
  end

  def author
    User.find_by_id(self.user_id)
  end

  def question
    Question.find_by_id(self.question_id)
  end

  def parent_reply
    if parent_reply_id 
      Reply.find_by_id(parent_reply_id)
    end
  end

  def child_replies
    # all_replies = Reply.find_by_question_id(question_id)
    # all_replies.reject{ |reply| reply['id'] == parent_reply_id }

    Reply.find_by_parent_id(self.id)
  end
end
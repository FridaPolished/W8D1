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

class User
  attr_accessor :id, :fname, :lname

  def self.find_by_name(fname, lname)
    query_result = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
    SELECT               
      *
    FROM
      users
    WHERE
      users.fname = ? AND users.lname = ?
    SQL
    
    query_result.map {|user| User.new(user)} 
  end

  def self.find_by_id(id)
    query_result = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT               
      *
    FROM
      users
    WHERE
      users.id = ?
    SQL
    
    User.new(query_result.first) 
  end

  
  
  def initialize(options)
    @id = options['id'] 
    @fname = options['fname']
    @lname = options['lname']  
    end

    def authored_questions
        Question.find_by_author_id(self.id) 
    end

    def authored_replies
        Reply.find_by_user_id(self.id)
    end
end
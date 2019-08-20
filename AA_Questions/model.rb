class Model 
   
    def self.find_by_id(id)
        raise "#{self} does not exist" unless self.id 
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            questions
        WHERE
            questions.id = ?
        SQL

        Question.new(data)
    end
    
end


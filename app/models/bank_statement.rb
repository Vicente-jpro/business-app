class BankStatement 
    attr_accessor :initial_date, :final_date

    def self.bank_statements 
      where(:initial_date, :final_date)  
    end
end
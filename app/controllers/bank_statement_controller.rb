class BankStatementController < ApplicationController
  def index
    @account = Account.where(account_params)
  end
  
  private 
    def account_params 
      params.require(:bank_statement).permit(:initial_date, :final_date)
    end

end

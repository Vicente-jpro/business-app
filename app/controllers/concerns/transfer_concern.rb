module TransferConcern
	extend ActiveSupport::Concern

	def transfer(transfere_params)
 
      origem_params = transfere_params
      destination_params = transfere_params
      money_to_transfere = origem_params[:money].to_f
 
      @account = Account.find_by_account_number(destination_params[:destination_account])
      
      @origin_account = Account.find_by_account_number(origem_params[:number])
 
      if account_loked?
        redirect_to transference_page(origem_params)
        invalid_account_message
      elsif do_not_have_enough_money_to_transfer?(origem_params)
        redirect_to transference_page(origem_params)
        flash[:alert]="Invalid money."
      elsif @account.nil?
        redirect_to transference_page(origem_params)
        invalid_account_message
      elsif money_to_transfere < 0 or @origin_account.money <= money_to_transfere
          redirect_to transference_page(origem_params)
          flash[:alert]="Invalid money."
      else 
          #transfere put the money to destination account
          new_money = @account.money + money_to_transfere
          destination_params[:money] = new_money
      
          destination_params[:number] = destination_params[:destination_account]
          @account.update(destination_params)
   
          #take money transfered from origem account
          origem_params[:money] = money_to_transfere
          #origem_params[:number] = params[:number]

          new_money = @origin_account.money - money_to_transfere
 
          origem_params[:money] = new_money - transfer_rate(origem_params)
           return origem_params
          
      end
     
	 end
   
end
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
        flash[:notice]="Invalid money."
      elsif @account.nil?
        redirect_to transference_page(origem_params)
        invalid_account_message
      elsif money_to_transfere < 0 or @origin_account.money <= money_to_transfere
          redirect_to transference_page(origem_params)
          flash[:notice]="Invalid money."
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
          debugger
          return origem_params
      end
	 end
   private
     def transfer_rate(origem_params)
          if money_up_to_one_thousand?(origem_params)
            return transfer_rate_of_ten_reais
          elsif is_saturday_or_sunday?
            return transfer_rate_of_seven_reais
            elsif hours_between_nine_and_eighteen?
              return transfer_rate_of_five_reais
          else
            return transfer_rate_of_seven_reais
          end
      end

      def money_up_to_one_thousand?(origem_params)
        ( origem_params[:money].to_f > 1000 )
      end

      def is_saturday_or_sunday?
        ( (day_of_the_week == "Saturday") || (day_of_the_week == "Sunday") )
      end

      def hours_between_nine_and_eighteen?
          ( (hours >= 9) && (hours <= 18) )
      end

      def day_of_the_week 
        Date.today.strftime('%A')
      end

      def hours      
        time = Time.new.to_s
        time_array = time.split
        hours = time_array[1].split(":").first
        return hours.to_i 
      end
      
      def transfer_rate_of_seven_reais
        7
      end
      
      def transfer_rate_of_five_reais
        5
      end
      
      def transfer_rate_of_ten_reais
        10
      end

    def do_not_have_enough_money_to_transfer?(origem_params)
      money_to_transfere = params[:money].to_f
      @account.money -= money_to_transfere
      params[:money] = @account.money - transfer_rate(origem_params)
      money = params[:money].to_f
      
      if money < 0
        return true 
      else 
        return false
      end
    end
   
   def transference_page(origem_params)
     "/accounts/"+origem_params[:number]+"/transference"
   end
end
module TransferRateConcern 
	extend ActiveSupport::Concern

    
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
      
    private
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
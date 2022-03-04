class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show edit update destroy account_update_params ]
  before_action :set_origin_account, only: [ :withdraw, :change_account_status, :transference, :do_not_have_enough_money_to_transfer? ]
  before_action :authenticate_user!
  # GET /accounts or /accounts.json
  
  #POST '/accounts/:number/transference_now'
  def transference_now
    my_params = account_transfere_now_params
    money_to_transfere = params[:money].to_f
    
      @account = Account.find_by_account_number(params[:destination_account])
      @origin_account = Account.find_by_account_number(params[:number])
      if account_loked?
        redirect_to transference_page
        invalid_account_message
      elsif do_not_have_enough_money_to_transfer? 
        redirect_to transference_page
        flash[:notice]="Invalid money."
      elsif @account.nil?
        redirect_to transference_page
        invalid_account_message
      elsif money_to_transfere < 0 or @origin_account.money <= money_to_transfere
          redirect_to transference_page
          flash[:notice]="Invalid money."
      else 
          #transfere the money
          @account.money += money_to_transfere
          my_params[:money] = @account.money
          my_params[:number] = params[:destination_account]
          @account.update(my_params)
       
          #take money transfered from my account
          my_params[:money] = money_to_transfere
          my_params[:number] = params[:number]

          @account = @origin_account
          @account.money -= money_to_transfere
          my_params[:money] = @account.money - transfer_rate
          
          respond_to do |format|
            if @account.update(my_params)
              format.html { redirect_to account_url(@account), notice: "Money was transfered successfully." }
              format.json { render :show, status: :ok, location: @account }
            else
              format.html { render :edit, status: :unprocessable_entity }
              format.json { render json: @account.errors, status: :unprocessable_entity }
            end
          end

      end
     
  end

  #GET numero da conta para efectuar o saque
  # GET /accounts/:number/withdraw
  def withdraw
    account = @account
    account.money = 0.0;
    @account_withdraw = account
    button_name("Take money")
  end

  # GET /accounts/:number/change_account_status
  def change_account_status

    if @account.nil?
      redirect_to "/new"
    else
      account = { 
      id: @account.id,
      number: @account.number,
      money: @account.money,
      status: "locked",
      user_id: @account.user_id,
      }
      if account_loked?
        account[:status] = "activated"
      end
 
      @account.update(account)

      redirect_to @account
    end
  end
  
  def account_loked?
    if @account.nil?
      false
    else
       @account.status == "locked" or @account.status == "blocked"
    end
  end 
   # GET /accounts/:number/transference
  def transference
    button_name("Transfere money")
  end


  # POST /accounts or /accounts.json
  def create
    if account_params[:money].to_f < 0.0
      redirect_to '/accounts/new' , notice: "Invalid money"
    else
    @account = Account.new(account_params)
    @account.user_id = current_user.id
    @account.number = new_accout_number

    respond_to do |format|
      if @account.save
        format.html { redirect_to account_url(@account), notice: "Account was successfully created." }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end


  end

  # PATCH/PUT /accounts/1 or /accounts/1.json
  def update
      if account_update_params[:money].to_f > @account.money.to_f
        redirect_to "/accounts/"+@account.number.to_s+"/withdraw"
        flash[:notice]="Money should less than or equal to $ "+@account.money.to_s
      elsif account_update_params[:money].to_f < 0
        redirect_to "/accounts/"+@account.number.to_s+"/withdraw" 
        flash[:notice]="Money should greater than or equal to $ 0"
      else
      
      respond_to do |format|
        if @account.update(account_update_params)
          format.html { redirect_to account_url(@account), notice: "Congratulation you taked your money successfully." }
          format.json { render :show, status: :ok, location: @account }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @account.errors, status: :unprocessable_entity }
        end
      end
    end
  end



  def index
    @accounts = Account.all
  end

  # GET /accounts/1 or /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
    @account = Account.new
    button_name("New account")
  end

  # GET /accounts/1/edit
  def edit
  end
   # GET /accounts/1/user
  def user_accounts
    @accounts = Account.find_user_accounts(current_user.id)
  end

  # DELETE /accounts/1 or /accounts/1.json
  def destroy
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_url, notice: "Account was successfully destroyed." }
      format.json { head :no_content }
    end
  end

    def button_name(name) 
      @button_name = name
      return @button_name
    end


  private
    def transfer_rate
        if money_up_to_one_thousand?
          return transfer_rate_of_ten_reais
        elsif is_saturday_or_sunday?
          return transfer_rate_of_seven_reais
          elsif hours_between_nine_and_eighteen?
            return transfer_rate_of_five_reais
        else
          return transfer_rate_of_seven_reais
        end
    end

    def money_up_to_one_thousand?
      ( params[:money].to_f > 1000 )
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
    
    def do_not_have_enough_money_to_transfer? 
      money_to_transfere = params[:money].to_f
      @account.money -= money_to_transfere
      params[:money] = @account.money - transfer_rate
      money = params[:money].to_f
      
      if money < 0
        return true 
      else 
        return false
      end
    end
    
    def transference_page
       "/accounts/"+params[:number]+"/transference"
    end

    def invalid_account_message
      flash[:notice]="Invalid destination account."
    end

    def set_origin_account
      @account = Account.find_by_account_number(params[:number].to_i)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_params
      params.require(:account).permit(:money, :status)
    end
    
    def account_transfere_now_params
     params.permit(:money, :number, :destination_account)
    end

    def account_update_params
      my_params = params.require(:account).permit(:money, :status)

      if my_params[:money].to_f < 0
        return my_params
      else
       my_params[:money] = @account.money - my_params[:money].to_f
      return my_params
      end
    end


    def new_accout_number
      @last_user_account = Account.last

      if !@last_user_account.nil?
          @last_user_account.number = @last_user_account.number + 1
      else
        #Default account number
        @last_user_account = Account.new(number:1000)
      end
      return @last_user_account.number
    end

end
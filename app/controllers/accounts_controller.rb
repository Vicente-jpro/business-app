class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show edit update destroy account_update_params ]
  # GET /accounts or /accounts.json
  
  #POST '/accounts/transference_now'
  def transference_now
    @account = Account.find_by_account_number(params[:number])                     
   # @account_destination = Account.destination_account
   debugger
    if account_transfere_now_params[:money].to_f > @account.money.to_f
      redirect_to "/accounts/"+@account.number.to_s+"/withdraw"
      flash[:notice]="Money should less than or equal to $ "+@account.money.to_s
    elsif account_transfere_now_params[:money].to_f < 0
      redirect_to "/accounts/"+@account.number.to_s+"/withdraw" 
      flash[:notice]="Money should greater than or equal to $ 0"
    else

      respond_to do |format|
        if @account.update(account_transfere_now_params)
          format.html { redirect_to account_url(@account), notice: "Account was successfully updated." }
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
    @account = Account.find_by_account_number(params[:number])
    account = @account
    account.money = 0.0;
    @account_withdraw = account
    button_name("Take money")
  end

   # POST /accounts/:number/withdraw
  def transference
    @account = Account.find_by_account_number(params[:number])
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
        flash[:notice]="Money should greater than or equal to $ "+0.to_s
      else
      
      respond_to do |format|
        if @account.update(account_update_params)
          format.html { redirect_to account_url(@account), notice: "Account was successfully updated." }
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
    @accounts = Account.where(user_id: current_user.id)
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
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_params
      params.require(:account).permit(:money, :status)
    end
    
    def account_transfere_now_params
      params.require(:account).permit(:money, :number, :destination_account_number)
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
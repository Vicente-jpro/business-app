class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show edit update destroy ]

  # GET /accounts or /accounts.json
  def index
    @accounts = Account.all
  end

  # GET /accounts/1 or /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end
   # GET /accounts/1/user
  def user_accounts
    @accounts = Account.where(user_id: current_user.id)
  end
  
  #GET numero da conta para efectuar o saque
  # GET /accounts/:number/withdraw
  def withdraw
    @account = Account.where(params[:number]).first
    account = @account
    account.money = 0.0;
    @account_withdraw = account

    logger.debug {"Last acount attributes hash: #{@account_withdraw.attributes.inspect}"}
  end



  # POST /accounts or /accounts.json
  def create
    
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

  # PATCH/PUT /accounts/1 or /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to account_url(@account), notice: "Account was successfully updated." }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1 or /accounts/1.json
  def destroy
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_url, notice: "Account was successfully destroyed." }
      format.json { head :no_content }
    end
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

    def new_accout_number
      @last_user_account = Account.last

    logger.debug {"Last acount attributes hash: #{@last_user_account.attributes.inspect}"}
      if !@last_user_account.nil?
          @last_user_account.number = @last_user_account.number + 1
      end

      return @last_user_account.number
    end
  
end

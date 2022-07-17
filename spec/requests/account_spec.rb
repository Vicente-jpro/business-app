require 'rails_helper'

RSpec.describe "Accounts", type: :request do
  describe "POST /transference_now" do
    let(:account) {create(:account)}

      it "show transfere" do
       get "/transference_now" , params: { money: acount.money, number:account.number, destination_account: )} 
      end

  end
end

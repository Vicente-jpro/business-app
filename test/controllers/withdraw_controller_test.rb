require "test_helper"

class WithdrawControllerTest < ActionDispatch::IntegrationTest
  test "should get account" do
    get withdraw_account_url
    assert_response :success
  end
end

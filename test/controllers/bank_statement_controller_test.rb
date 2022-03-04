require "test_helper"

class BankStatementControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bank_statement_index_url
    assert_response :success
  end
end

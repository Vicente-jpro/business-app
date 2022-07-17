FactoryBot.define do
  factory :account_history do
    id { 1 }
    number_history { 1 }
    money_history { 1.5 }
    status_history { "MyString" }
    user_id { 1 }
    created_at { "2022-07-17 11:58:52" }
    updated_at { "2022-07-17 11:58:52" }
  end
end

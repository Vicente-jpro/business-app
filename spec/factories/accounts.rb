FactoryBot.define do
  factory :account do
    id { 1 }
    number { 1 }
    money { 1.5 }
    status { "MyString" }
    user_id { 1 }
    created_at { "2022-07-17 11:58:48" }
    updated_at { "2022-07-17 11:58:48" }
  end
end

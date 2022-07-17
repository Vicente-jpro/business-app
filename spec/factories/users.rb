FactoryBot.define do
  factory :user do
    id { 1 }
    username { "MyString" }
    email { "MyString" }
    encrypted_password { "MyString" }
    reset_password_token { "MyString" }
    reset_password_sent_at { "2022-07-17 11:58:44" }
    remember_created_at { "2022-07-17 11:58:44" }
    created_at { "2022-07-17 11:58:44" }
    updated_at { "2022-07-17 11:58:44" }
  end
end

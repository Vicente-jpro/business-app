json.extract! account, :id, :number, :money, :status, :user_id, :created_at, :updated_at
json.url account_url(account, format: :json)

class Account < ApplicationRecord
  belongs_to :user
  enum :status [blocked: "blocked", activated: "activated"]
end

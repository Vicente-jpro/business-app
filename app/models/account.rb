class Account < ApplicationRecord
  belongs_to :user
  enum status: {blocked: "blocked", activated: "activated"}

  validate :number, presence: true, 
  validate :money, presence: true, length: {minimum:0.5}

end

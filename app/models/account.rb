class Account < ApplicationRecord
  belongs_to :user
  enum status: {blocked: "blocked", activated: "activated"}

  validates :number, presence: true
  validates :money, presence: true, length: {minimum:1}
   
end

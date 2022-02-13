class Account < ApplicationRecord
  belongs_to :user
  enum status: {blocked: "blocked", activated: "activated"}

  validates :number, presence: true, uniqueness: true 
  validates :money, presence: true, length: {minimum:1}

  def self.find_by_account_number(account_number)
    find_by_number(account_number)
  end
end

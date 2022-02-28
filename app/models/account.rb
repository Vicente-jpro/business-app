class Account < ApplicationRecord
  attr_accessor :destination_account

  belongs_to :user
  enum status: {locked: "locked", activated: "activated"}
  
  validates :number, presence: true, uniqueness: true 
  validates :money, presence: true, numericality: { greater_than: 1}

  def self.find_by_account_number(account_number)
    find_by_number(account_number)
  end

  def self.find_user_accounts(user_id)
    where(user_id: user_id)
  end
end

class Account < ApplicationRecord
  attr_accessor :destination_account

  belongs_to :user
  enum status: {blocked: "locked", activated: "activated"}
  
  validates :number, presence: true, uniqueness: true 
  validates :money, presence: true, numericality: { greater_than: 1}

  def self.find_by_account_number(account_number)
    find_by_number(account_number)
  end

  def destination_account=(account_number)
    account = Account.find_by_number(account_number.to_i)
    return account[:number]
  end
  
end

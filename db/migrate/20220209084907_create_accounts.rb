class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.integer :number
      t.float :money
      t.string :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

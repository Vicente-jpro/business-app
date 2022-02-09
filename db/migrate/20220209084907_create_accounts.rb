class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.integer :number, default: 10000
      t.float :money, default: 0.5
      t.string :status, default: "activated"
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

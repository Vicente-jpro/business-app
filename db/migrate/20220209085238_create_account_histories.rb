class CreateAccountHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :account_histories do |t|
      t.integer :number_history
      t.float :money_history
      t.string :status_history
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

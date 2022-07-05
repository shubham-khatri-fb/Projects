class CreateUserTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :user_transactions do |t|
      t.integer :user_id
      t.integer :user_id_transaction_made
      t.integer :transaction_id
      t.integer :transaction_type

      #t.timestamps
    end
  end
end

class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.decimal :conversion_rate
      t.decimal :amount_transfer
      t.integer :transfer_currency_type
      t.integer :receive_currency_type

      t.timestamps
    end
  end
end

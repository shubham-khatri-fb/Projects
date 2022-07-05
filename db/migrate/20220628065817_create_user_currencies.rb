class CreateUserCurrencies < ActiveRecord::Migration[6.0]
  def change
    create_table :user_currencies do |t|
      t.integer :user_id
      t.integer :currency_type
      t.decimal :amount

      t.timestamps
    end
  end
end

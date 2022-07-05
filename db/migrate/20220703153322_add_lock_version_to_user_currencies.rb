class AddLockVersionToUserCurrencies < ActiveRecord::Migration[6.0]
  def change
    add_column :user_currencies, :lock_version, :integer, default: 0, null: false
  end
end

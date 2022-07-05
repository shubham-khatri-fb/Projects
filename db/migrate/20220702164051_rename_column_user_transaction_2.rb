class RenameColumnUserTransaction2 < ActiveRecord::Migration[6.0]
  def change
    rename_column :user_transactions, :all_transactions_id, :all_transaction_id
  end
end

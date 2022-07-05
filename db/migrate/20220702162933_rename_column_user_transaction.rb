class RenameColumnUserTransaction < ActiveRecord::Migration[6.0]
  def change
    rename_column :user_transactions, :transaction_id, :all_transactions_id
  end
end

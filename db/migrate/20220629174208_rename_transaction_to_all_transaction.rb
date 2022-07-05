class RenameTransactionToAllTransaction < ActiveRecord::Migration[6.0]
  def change
    rename_table :transactions, :all_transactions
  end
end

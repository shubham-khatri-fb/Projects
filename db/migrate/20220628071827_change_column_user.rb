class RenameColumnUser < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :phone_number, :bigint, unique: true
  end
end

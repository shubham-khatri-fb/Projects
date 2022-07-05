class AddColumnToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :authy_id, :integer, null: true
    add_column :users, :email, :string, null: true
  end
end

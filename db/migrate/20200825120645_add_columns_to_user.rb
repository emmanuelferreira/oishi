class AddColumnsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :username, :string
    add_column :users, :picture, :string
    add_reference :users, :address, null: false, foreign_key: true
  end
end

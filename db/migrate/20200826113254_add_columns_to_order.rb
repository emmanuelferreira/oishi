class AddColumnsToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :subtotal, :float
    add_column :orders, :total, :float
    add_column :orders, :tax, :float
    add_column :orders, :shipping, :float
  end
end

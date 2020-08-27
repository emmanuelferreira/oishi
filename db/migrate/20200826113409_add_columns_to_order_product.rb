class AddColumnsToOrderProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :order_products, :unit_price, :float
    add_column :order_products, :total_price, :float
  end
end

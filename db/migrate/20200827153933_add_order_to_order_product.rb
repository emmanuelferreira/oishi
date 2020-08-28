class AddOrderToOrderProduct < ActiveRecord::Migration[6.0]
  def change
    add_reference :order_products, :order, null: false, foreign_key: true
  end
end

class RemoveOrderFromOrderProducts < ActiveRecord::Migration[6.0]
  def change
    remove_reference :order_products, :order, null: false, foreign_key: true
  end
end

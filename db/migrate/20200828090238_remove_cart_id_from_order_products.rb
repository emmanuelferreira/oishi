class RemoveCartIdFromOrderProducts < ActiveRecord::Migration[6.0]
  def change
    remove_reference :order_products, :cart, index: true, foreign_key: true 
  end
end

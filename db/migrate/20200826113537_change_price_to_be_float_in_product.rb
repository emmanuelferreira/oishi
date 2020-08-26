class ChangePriceToBeFloatInProduct < ActiveRecord::Migration[6.0]
  def change
     change_column :products, :price, :float
  end
end

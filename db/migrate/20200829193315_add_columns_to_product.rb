class AddColumnsToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :quantity_product, :string
    add_column :products, :image_nutrition, :string
  end
end

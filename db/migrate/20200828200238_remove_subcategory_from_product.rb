class RemoveSubcategoryFromProduct < ActiveRecord::Migration[6.0]
  def change
    remove_reference :products, :subcategory, null: false, foreign_key: true
  end
end

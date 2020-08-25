class AddSubcategoryToProducts < ActiveRecord::Migration[6.0]
  def change
    add_reference :products, :subcategory, null: false, foreign_key: true
  end
end

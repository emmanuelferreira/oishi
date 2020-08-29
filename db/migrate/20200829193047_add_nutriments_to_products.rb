class AddNutrimentsToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :nutriments, :hstore, default: {}, null: false
  end
end

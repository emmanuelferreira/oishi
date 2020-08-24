class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :barcode
      t.string :name
      t.references :category, null: false, foreign_key: true
      t.text :description
      t.string :origin
      t.date :expiration_date
      t.string :availability
      t.integer :price
      t.string :currency
      t.integer :nutri_score
      t.integer :eco_score
      t.references :supplier, null: false, foreign_key: true
      t.string :image

      t.timestamps
    end
  end
end

class CreateSuppliers < ActiveRecord::Migration[6.0]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.references :address, null: false, foreign_key: true
      t.text :description
      t.string :url
      t.string :phone

      t.timestamps
    end
  end
end

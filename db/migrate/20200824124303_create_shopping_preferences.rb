class CreateShoppingPreferences < ActiveRecord::Migration[6.0]
  def change
    create_table :shopping_preferences do |t|
      t.string :name

      t.timestamps
    end
  end
end

class CreateUserPreferences < ActiveRecord::Migration[6.0]
  def change
    create_table :user_preferences do |t|
      t.references :user, null: false, foreign_key: true
      t.references :shopping_preference, null: false, foreign_key: true
      t.integer :order

      t.timestamps
    end
  end
end

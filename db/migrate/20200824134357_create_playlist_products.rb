class CreatePlaylistProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :playlist_products do |t|
      t.references :playlist, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end

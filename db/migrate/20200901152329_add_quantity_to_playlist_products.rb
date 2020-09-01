class AddQuantityToPlaylistProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :playlist_products, :quantity, :integer
  end
end

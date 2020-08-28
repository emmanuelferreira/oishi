class RemoveCarts < ActiveRecord::Migration[6.0]
  def change
    drop_table :carts
  end
end

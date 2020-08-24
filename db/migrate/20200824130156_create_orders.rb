class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :status
      t.references :user, null: false, foreign_key: true
      t.date :deliver_date
      t.references :address, null: false, foreign_key: true
      t.string :payment_status
      t.integer :payment_amount
      t.string :payment_type

      t.timestamps
    end
  end
end

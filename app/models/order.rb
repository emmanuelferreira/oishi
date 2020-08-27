class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_many :order_products
  before_save :set_subtotal

  def subtotal
    order_products.collect {|order_product| order_product.valid? ? (order_product.unit_price*order_product.quantity) : 0}.sum
  end

  private
    def set_subtotal
      self[:subtotal] = subtotal
    end
end

class OrderProduct < ApplicationRecord
  belongs_to :product
  belongs_to :order
  before_save :set_unit_price
  before_save :set_total_price

  def price_per_unit
    if persisted?
      self[price_per_unit]
    else
      product.price
    end
  end

  def tot_price
    price_per_unit * quantity
  end

  private

  def set_unit_price
    self[:unit_price] = price_per_unit
  end

  def set_total_price
    self[:total_price] = quantity * set_unit_price
  end
end

class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_many :order_products
  accepts_nested_attributes_for :order_products
end

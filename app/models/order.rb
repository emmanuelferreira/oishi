class Order < ApplicationRecord
  belongs_to :user, :address
  has_many :order_products
  has_many :products through: :order_products

  validates :status, :user, presence: true
end

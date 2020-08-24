class Supplier < ApplicationRecord
  belongs_to :address
  has_many :products
  has_many :inventories
end

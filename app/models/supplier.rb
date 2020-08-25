class Supplier < ApplicationRecord
  belongs_to :address, optional: true
  has_many :products
  has_many :inventories
end

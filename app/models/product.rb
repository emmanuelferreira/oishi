class Product < ApplicationRecord
  belongs_to :category
  belongs_to :supplier
  has_many :inventories
  has_many :orders, through: :order_products
  has_many :playlist_products
  has_many :playlists, through: :playlist_products
  validates :barcode, :name, :description, :origin, :price, presence: true
end

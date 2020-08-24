class Playlist < ApplicationRecord
 has_many :playlist_products
 has_many :products, through: :playlist_products
end

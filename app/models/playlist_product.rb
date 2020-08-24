class PlaylistProduct < ApplicationRecord
  belongs_to :playlist
  belongs_to :product
end

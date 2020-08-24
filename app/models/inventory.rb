class Inventory < ApplicationRecord
  belongs_to :product
  belongs_to :supplier
  validates :on_hand, presence: true
end

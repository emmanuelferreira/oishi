class ShoppingPreference < ApplicationRecord
  belong_to :user_preference

  validates :name, presence: true
end

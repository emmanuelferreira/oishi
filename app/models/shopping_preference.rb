class ShoppingPreference < ApplicationRecord
  has_many :user_preferences

  validates :name, presence: true
  validates :name, inclusion: {in: %w(prix nutriscore ecoscore)} 
end

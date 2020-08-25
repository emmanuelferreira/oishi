class UserPreference < ApplicationRecord
  belongs_to :user
  belongs_to :shopping_preference

  validates :user, :shopping_preference, :order, presence: true
end

class UserPreference < ApplicationRecord
  belongs_to :user
  has_many :shopping_preferences

  validates :user, :shopping_preference, presence :true
end

class UserPreference < ApplicationRecord
  belongs_to :user
  has_many :shopping_preference

  validates :user, :shopping_preference, presence :true
end

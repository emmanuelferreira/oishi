class UserPreference < ApplicationRecord
  belongs_to :user
  belongs_to :shopping_preference
end

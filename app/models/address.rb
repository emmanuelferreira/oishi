class Address < ApplicationRecord
  belong_to :user

  validates :street, :city, :zip, presence: true
end

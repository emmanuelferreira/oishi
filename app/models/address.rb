class Address < ApplicationRecord
  belongs_to :user
  belongs_to :supplier
  has_many :orders

  validates :street, :city, :zip, presence: true
end

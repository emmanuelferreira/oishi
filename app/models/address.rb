class Address < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :supplier, optional: true
  has_many :orders

  validates :street, :city, :zip, presence: true
end

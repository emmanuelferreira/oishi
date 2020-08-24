class Address < ApplicationRecord
  belongs_to :user
  belongs_to :supplier
  belongs_to :order

  validates :street, :city, :zip, presence: true
end

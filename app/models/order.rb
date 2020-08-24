class Order < ApplicationRecord
  belongs_to :user, :address


  validates :status, :user, :deliver_date, :address, :payment_status, :payment_amount, :payment_type
end

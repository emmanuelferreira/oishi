class OrdersController < ApplicationController
  def create
    @order = Order.new(
    status: "pending",
    user_id:
    deliver_date:,
    address_id:,
    total:
  end
end

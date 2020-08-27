class CartsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @cart = @current_cart
    @order_items = OrderProduct.all
  end

end

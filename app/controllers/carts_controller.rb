class CartsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @order_products = @current_cart.order_products
  end
end

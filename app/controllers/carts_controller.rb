class CartsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @cart = @current_cart
  end

end

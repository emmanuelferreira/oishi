class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @products = Product.all
    @suppliers = Supplier.all
    @order_product = @current_order.order_products.new
  end

end



class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @products = Product.includes(:subcategory)
    @suppliers = Supplier.all
    @order_product = @current_cart.order_products.new
  end

end



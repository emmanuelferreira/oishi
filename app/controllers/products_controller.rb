class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @products = Product.includes(:subcategory)
    @suppliers = Supplier.all
    @order_product = OrderProduct.new
  end

end



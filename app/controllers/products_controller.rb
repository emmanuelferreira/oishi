class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    if params[:query].present?
      @products = Product.where(subcategory: params[:query])
      @suppliers = Supplier.all
      @order_product = OrderProduct.new
    else
      @products = Product.includes(:subcategory)
      @suppliers = Supplier.all
      @order_product = OrderProduct.new
    end
  end

  def show
    @product = Product.includes(:subcategory).find(params[:id])
  end
end



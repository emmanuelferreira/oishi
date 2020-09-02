class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    if params[:query].present?
      @products = Product.where(category_id: Category.find_by(name: params[:query]).id).sort_by(&:eco_score)
      @suppliers = Supplier.all
      @order_product = OrderProduct.new
    elsif params[:sort_eco].present?
      @products = Product.all.sort_by(&:eco_score)
      @suppliers = Supplier.all
      @order_product = OrderProduct.new
    elsif params[:sort_nutri].present?
      @products = Product.all.sort_by(&:nutri_score)
      @suppliers = Supplier.all
      @order_product = OrderProduct.new
    elsif params[:sort_price].present?
      @products = Product.all.sort_by(&:price)
      @suppliers = Supplier.all
      @order_product = OrderProduct.new
    else
      @products = Product.includes(:category).sort_by(&:eco_score)
      @suppliers = Supplier.all
      @order_product = OrderProduct.new
      if params[:search].present?
        @products = []
        @products << Product.find_by(barcode: params[:search])
      end
    end
  end


  def show
    @product = Product.includes(:category).find(params[:id])
    @order_product = OrderProduct.new
  end
end



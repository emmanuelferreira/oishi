class OrderProductsController < ApplicationController
  skip_before_action :authenticate_user!


  def create
    @cart = @current_cart
    @order_product = @cart.order_products.new(order_product_params)
    @cart.save
    session[:cart_id] = @cart.id
  end

  def update
    @cart = current_cart
    @order_product = @cart.order_products.find(params[:id])
    @order_product.update_attributes(order_product_params)
    @order_products = @cart.order_products
  end

  def destroy
    @cart = @current_cart
    @order_product = @cart.order_products.find(params[:id])
    @order_product.destroy
    @order_products = @cart.order_products
  end

  private

  def order_product_params
    params.require(:order_product).permit(:product_id, :quantity, :unit_price, :total_price)
  end
end


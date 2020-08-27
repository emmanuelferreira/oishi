class OrderProductsController < ApplicationController
  skip_before_action :authenticate_user!


  def create
    if @current_cart.key?(order_product_params[:product_id])
      @current_cart[order_product_params[:product_id]] += order_product_params[:quantity].to_i
    else
      @current_cart[order_product_params[:product_id]] = order_product_params[:quantity].to_i
    end
    session[:cart] = @current_cart
  end

  def update
    @cart = @current_cart
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
    params.require(:order_product).permit(:product_id, :quantity)
  end
end


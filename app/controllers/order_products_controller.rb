class OrderProductsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    @order = @current_order
    order_product = @order.order_products.new(order_product_params)
    session[:order_id] = @order.id
    @order.save

  end

  def update
    @order = current_order
    @order_product = @order.order_products.find(params[:id])
    @order_product.update_attributes(order_product_params)
    @order_products = @order.order_products
  end

  def destroy
    @order = current_order
    @order_product = @order.order_products.find(params[:id])
    @order_product.destroy
    @order_products = @order.order_products
  end

  private

  def order_product_params
    params.require(:order_product).permit(:product_id, :quantity)
  end
end


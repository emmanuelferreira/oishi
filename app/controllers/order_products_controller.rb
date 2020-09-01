class OrderProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :remove_from_cart, :delete_from_cart]


  def create
    if @current_cart.key?(order_product_params[:product_id])
      @current_cart[order_product_params[:product_id]] += order_product_params[:quantity].to_i
    else
      @current_cart[order_product_params[:product_id]] = order_product_params[:quantity].to_i
    end
    session[:cart] = @current_cart
    redirect_to products_path
  end

  def remove_from_cart
    if @current_cart.key?(order_product_params[:product_id])
      @current_cart[order_product_params[:product_id]] = order_product_params[:quantity].to_i
    end
    session[:cart] = @current_cart
    render 'create'
    redirect_to "carts_path"
  end

  def delete_from_cart
    if @current_cart.key?(params[:product_id])
      @current_cart.delete(params[:product_id])
    end
    session[:cart] = @current_cart
    render 'create'
  end


  private

  def order_product_params
    params.require(:order_product).permit(:product_id, :quantity)
  end
end


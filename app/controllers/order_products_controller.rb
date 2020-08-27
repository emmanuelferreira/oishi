class OrderProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :remove_from_cart, :delete_from_cart]


  def create
    if @current_cart.key?(order_product_params[:product_id])
      @current_cart[order_product_params[:product_id]] += order_product_params[:quantity].to_i
    else
      @current_cart[order_product_params[:product_id]] = order_product_params[:quantity].to_i
    end
    session[:cart] = @current_cart
  end

  def remove_from_cart
    if @current_cart.key?(order_product_params[:product_id])
      @current_cart[order_product_params[:product_id]] = order_product_params[:quantity].to_i
    end
    session[:cart] = @current_cart
    render "create"
  end

  def delete_from_cart
    if @current_cart.key?(order_product_params[:product_id])
      @current_cart.reject{ |product_id, quantity| product_id.to_i == order_product_params[:product_id].to_i }
    end
    session[:cart] = @current_cart
    render "create"
  end

  def save
    @order = Order.new(
      status: "pending",
      user_id: @current_user.id,
      deliver_date: Date.today + 1,
      address_id: @current_user.address.id,
      total: @cart_amount
      )
    @order.save

    @current_cart.each do |product_id, quantity|
      order_product = OrderProduct.new(
        product_id: product_id,
        quantity: quantity,
        unit_price: Product.find(product_id).price,
        order_id: @order.id
        )
      order_product.save
    end

  end

  private

  def order_product_params
    params.require(:order_product).permit(:product_id, :quantity)
  end
end


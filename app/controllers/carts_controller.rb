class CartsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @order_products = []
    @current_cart.each do |product_id, quantity|
      order_product = OrderProduct.new(
        product_id: product_id,
        quantity: quantity,
        unit_price: Product.find(product_id).price
        )
      @order_products << order_product
    end
  end

end

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
    if @order_products.empty?
      flash[:notice] = 'Empty Cart, redirecting you to product browsing page...'
      sleep(5)
      redirect_to products_path
    end
  end

end

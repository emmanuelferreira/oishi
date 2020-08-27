class OrdersController < ApplicationController

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

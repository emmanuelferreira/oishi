class ChargesController < ApplicationController
  def new
  end

  def create
     @cart_amount = @current_cart.inject(0) do |sum, (key, quantity)|
           @product = Product.find(key)
           sum += @product.price * quantity
         end

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

    # Amount in cents
    @amount = @cart_amount * 100

    customer = Stripe::Customer.create({
      email: params[:stripeEmail],
      source: params[:stripeToken],
    })

    charge = Stripe::Charge.create({
      customer: customer.id,
      amount: @amount,
      description: 'Rails Stripe customer',
      currency: 'chf',
    })

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end

  @order.status = "In progress"

end

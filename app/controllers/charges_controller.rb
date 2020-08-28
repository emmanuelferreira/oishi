class ChargesController < ApplicationController
  def new
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

  def create
   @cart_amount = @current_cart.inject(0) do |sum, (key, quantity)|
      @product = Product.find(key)
      sum += @product.price * quantity
    end

   @order = Order.new(
     status: "Payment not accepted",
     user_id: current_user.id,
     deliver_date: Date.today + 1,
     address_id: current_user.address.id,
     total: @cart_amount
    )
   @order.save!

   @current_cart.each do |product_id, quantity|
      order_product = OrderProduct.new(
        product_id: product_id,
        quantity: quantity,
        unit_price: Product.find(product_id).price,
        order_id: @order.id
       )
      order_product.save!
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


    @order.status = "Pending"
    @current_cart = {}
    redirect_to dashboard_path, notice: 'Payment approved!'

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path

  end

end


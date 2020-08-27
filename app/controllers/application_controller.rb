class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :current_cart
  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_cart
    if session[:cart].present?
      @current_cart = session[:cart]
    else
      @current_cart = {}
    end

    @cart_amount = @current_cart.inject(0) do |sum, (key, quantity)|
      @product = Product.find(key)
      sum += @product.price * quantity
    end
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:[:firstname, :lastname, :username, address_attributes: [:street, :city, :zip]])
  end
end


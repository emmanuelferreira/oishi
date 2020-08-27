class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :current_cart
  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_cart
    if !session[:cart_id].nil?
      @current_cart = Cart.find(session[:cart_id])
    else
      @current_cart = Cart.new
    end
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:[:firstname, :lastname, :username, address_attributes: [:street, :city, :zip]])
  end
end


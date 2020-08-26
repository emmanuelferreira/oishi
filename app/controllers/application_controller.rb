class ApplicationController < ActionController::Base

  before_action :authenticate_user!
  before_action :current_order
  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_order
    if !session[:order_id].nil?
      @current_order = Order.find(session[:order_id])
    else
      @current_order = Order.new
    end
  end
end
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:[:firstname, :lastname, :username, address_attributes: [:street, :city, :zip]])
  end
end


class ApplicationController < ActionController::Base

  before_action :authenticate_user!
  before_action :current_order

  def current_order
    if !session[:order_id].nil?
      @current_order = Order.find(session[:order_id])
    else
      @current_order = Order.new
    end
  end
end

class DashboardsController < ApplicationController


  def overview
    @order = Order.where(user_id: current_user.id).last
    @order_products = OrderProduct.where(order_id: @order.id)
    @current_month_orders = Order.where('deliver_date >= ? and deliver_date <= ?', Time.now.beginning_of_month, Time.now.end_of_month)


    @current_eco_scores_table = []
    @current_eco_scores_table = []
    @current_month_orders.each do |order|
      @current_eco_scores_table << order.products.pluck(:eco_score).join.gsub("A", "6").gsub("B", "5").gsub("C", "4").gsub("D", "3").gsub("E", "2").gsub("F","1")
      @current_nutri_scores_table << order.products.pluck(:nutri_score).join.gsub("A", "6").gsub("B", "5").gsub("C", "4").gsub("D", "3").gsub("E", "2").gsub("F","1")
    end
    @current_eco_score_avg = (@current_eco_scores_table.split("").map(&:to_i).inject{ |sum, el| sum + el }.to_f / @current_eco_scores_table.split("").size)
    @current_nutri_score_avg = @current_nutri_scores_table.join.split("").map(&:to_i).inject{ |sum, el| sum + el }.to_f / @current_eco_scores_table.split("").size)
    @last_month_orders = Order.where('deliver_date >= ? and deliver_date <= ?', Time.now.beginning_of_month - 1.month, Time.now.end_of_month - 1.month)
  end

  def average_string


  end
end

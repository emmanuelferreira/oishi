class DashboardsController < ApplicationController


  def overview
    @last_order = Order.where(user_id: current_user.id).last
    @order_products = OrderProduct.where(order_id: @last_order.id)


    @current_month_orders = Order.where('deliver_date >= ? and deliver_date <= ?', Time.now.beginning_of_month, Time.now.end_of_month)
    @current_eco_scores_table = []
    @current_nutri_scores_table = []
    @current_month_orders.each do |order|
      order.products.pluck(:eco_score).join.gsub("A", "6").gsub("B", "5").gsub("C", "4").gsub("D", "3").gsub("E", "2").gsub("F","1").split("").each { |grade| @current_eco_scores_table << grade.to_i}
      order.products.pluck(:nutri_score).join.gsub("A", "6").gsub("B", "5").gsub("C", "4").gsub("D", "3").gsub("E", "2").gsub("F","1").split("").each { |grade| @current_nutri_scores_table << grade.to_i}
    end
    @current_eco_score_avg = ((@current_eco_scores_table.inject { |sum, el| sum + el }.to_f) / @current_eco_scores_table.size).round(0)
      .to_s.gsub("6","A").gsub("5", "B").gsub("4", "C").gsub("3", "D").gsub("2", "E").gsub("1", "F")
    @current_nutri_score_avg = ((@current_nutri_scores_table.inject { |sum, el| sum + el }.to_f) / @current_nutri_scores_table.size).round(0)
    .to_s.gsub("6","A").gsub("5", "B").gsub("4", "C").gsub("3", "D").gsub("2", "E").gsub("1", "F")


    @last_month_orders = Order.where('deliver_date >= ? and deliver_date <= ?', Time.now.beginning_of_month - 1.month, Time.now.end_of_month - 1.month)
    @last_eco_scores_table = []
    @last_nutri_scores_table = []
    @last_month_orders.each do |order|
      order.products.pluck(:eco_score).join.gsub("A", "6").gsub("B", "5").gsub("C", "4").gsub("D", "3").gsub("E", "2").gsub("F","1").split("").each { |grade| @last_eco_scores_table << grade.to_i}
      order.products.pluck(:nutri_score).join.gsub("A", "6").gsub("B", "5").gsub("C", "4").gsub("D", "3").gsub("E", "2").gsub("F","1").split("").each { |grade| @last_nutri_scores_table << grade.to_i}
    end
    @last_eco_score_avg = ((@last_eco_scores_table.inject { |sum, el| sum + el }.to_f) / @last_eco_scores_table.size).round(0)
      .to_s.gsub("6","A").gsub("5", "B").gsub("4", "C").gsub("3", "D").gsub("2", "E").gsub("1", "F")
    @last_nutri_score_avg = ((@last_nutri_scores_table.inject { |sum, el| sum + el }.to_f) / @last_nutri_scores_table.size).round(0)
    .to_s.gsub("6","A").gsub("5", "B").gsub("4", "C").gsub("3", "D").gsub("2", "E").gsub("1", "F")
  end

  def average_string


  end
end

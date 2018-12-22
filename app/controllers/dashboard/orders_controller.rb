class Dashboard::OrdersController < ApplicationController


  def show
    @order = Order.find(params[:id])
    @user = @order.user #customer

    @order_items = current_user.my_order_items(@order)
  end


end

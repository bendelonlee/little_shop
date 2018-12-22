class Dashboard::UsersController < ApplicationController
  def show
    @user = current_user
    @orders = @user.merchant_pending_orders
    render template: 'dashboard/users/show'
  end
end

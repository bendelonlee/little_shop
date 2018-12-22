class Admin::UsersController < ApplicationController
  before_action :require_admin

  def show
    @user = User.find(params[:id])
    redirect_to admin_merchant_path(@user) if @user.role == "merchant"
  end

  def merchant_show
    @user = User.find(params[:id])
    if @user.role == "registered"
      redirect_to admin_user_path(@user)
    else
      @orders = @user.merchant_pending_orders
      render template: 'dashboard/users/show'
    end
  end

  def index
    @users = User.where(role: ["registered"])
  end

  def update
    user = User.find(params[:id])
    if user.enabled?
      user.update(enabled: false)
      flash[:notice] = "#{user.name} (id:#{user.id}) is now disabled."
    else
      user.update(enabled: true)
      flash[:notice] = "#{user.name} (id:#{user.id}) is now enabled."
    end
    if user.merchant?
      redirect_to merchants_path
    else
      redirect_to admin_users_path
    end
  end

  private

  def require_admin
    render file: "/public/404" unless current_admin?
  end
end

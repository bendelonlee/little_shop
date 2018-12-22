class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:message] = "You are registered and logged in"
      session[:user_id] = @user.id
      redirect_to profile_path(@user)
    else
      add_errors_on_flash(@user)
      render :new
    end
  end

  def show
    @user = current_user
  end

  def edit
  end

  def index
    if current_user && current_user.admin?
      @merchants = User.where(role: "merchant")
    else
      @merchants = User.where(enabled: true, role: "merchant")
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :address, :city, :state, :email, :password, :zip_code, :password_confirmation)
  end

end

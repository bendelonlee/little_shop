class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :add_errors_on_flash
  before_action :set_cart

  def set_cart
    @cart ||= Cart.new(session[:cart])
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_admin?
    current_user && current_user.admin?
  end

  def merchant_user?
   current_user && current_user.merchant?
  end

  def add_errors_on_flash(object_with_errors)
    object_with_errors.errors.each do |attribute, message|
      flash[attribute] = "#{error_prefix[object_with_errors.class.to_s]} #{attribute} #{message}."
    end
  end

  private

  def error_prefix
    {
      "User" => "Your",
      "Item" => "Item"
    }
  end


end

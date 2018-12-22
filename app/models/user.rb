class User < ApplicationRecord
  validates_presence_of :email, :name, :role, :address, :city, :state, :zip_code
  validates_presence_of :password, if: :password
  validates_uniqueness_of :email
  validates_confirmation_of :password

  has_many :orders
  has_many :items
  enum role: ["registered", "merchant", "admin"]

  has_secure_password

  def status
   enabled? ? "Enabled" : "Disabled"
  end

  def my_order_items(order)
    OrderItem.joins(:item).where(order: order, items: {user_id: self.id})
  end

  def merchant_pending_orders
    Order.joins(:items).select("orders.*").where("items.user_id=#{self.id}").where(orders: {status: :pending}).group(:id)
  end
end

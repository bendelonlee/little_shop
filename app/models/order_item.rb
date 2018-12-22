class OrderItem < ApplicationRecord
  validates_presence_of :price, :quantity
  # We could do on the database level by setting a default, but this works
  before_validation :ensure_quantity, :ensure_price

  belongs_to :item
  belongs_to :order

  def subtotal
    quantity * price
  end

  private

  def ensure_quantity
    self.quantity ||= 1
  end

  def ensure_price
    self.price ||= 1
  end

end

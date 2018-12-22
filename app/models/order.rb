class Order < ApplicationRecord
  validates_presence_of :status

  belongs_to :user
  has_many :order_items
  has_many :items, through: :order_items
  enum status: ["pending", "fulfilled", "cancelled"]

  def add_cart(cart)
    cart.contents.each do |item_id, qty|
      item = Item.find(item_id)
      order_items.create(item: item, price: item.price, quantity: qty)
    end
  end

  def total_quantity
    order_items.sum(:quantity)
  end

  def total_price
    order_items. sum("order_items.price * order_items.quantity")
  end

  def pending?
    status == 'pending'
  end
end

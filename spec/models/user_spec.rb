require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :email}
    it {should validate_uniqueness_of :email}
    it {should validate_presence_of :role}
    it {should validate_presence_of :password}
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip_code}
    it {should validate_confirmation_of :password}
  end
  describe 'relationships' do
    it {should have_many :items}
    it {should have_many :orders}
  end

  describe 'instance methods' do
    it '.status' do
      user = FactoryBot.create(:user)
      expect(user.status).to eq("Enabled")
      user.enabled = false
      expect(user.status).to eq("Disabled")
    end

    it '.merchant_pending_orders' do
      # Current_user
      user = FactoryBot.create(:merchant)

      # Another merchant
      user_2 = FactoryBot.create(:merchant)

      # Item for other merchant
      item_1 = FactoryBot.create(:item, user: user_2)

      # Item for current_user
      item_2 = FactoryBot.create(:item, user: user)

      # Order - pending -for other merchant - should not show up
      order_1 = FactoryBot.create(:pending, items: [item_1])

      # Order - pending -for current_user - should show up
      order_2 = FactoryBot.create(:pending)
      order_item = FactoryBot.create(:order_item, order: order_2, item: item_2)

      # Creates a second order to insure a list is populating to the page for the current_user.
      order_5 = FactoryBot.create(:pending)
      order_item_2 = FactoryBot.create(:order_item, order: order_5, item: item_2)

      # Order - cancelled -for current_user - should not show up
      order_3 = FactoryBot.create(:cancelled, items: [item_1, item_2])

      # Order - fulfilled -for current_user - should not show up
      order_4 = FactoryBot.create(:fulfilled, items: [item_1, item_2])

      expect(user.merchant_pending_orders).to eq([order_2, order_5])

    end
    it '.my_order_items(order)' do
      merchant = FactoryBot.create(:merchant)
      item_1 = FactoryBot.create(:item)
      item_2 = FactoryBot.create(:item)
      FactoryBot.create(:item)
      merchant.items << item_1

      order = FactoryBot.create(:order, items: [item_1, item_2])

      expect(merchant.my_order_items(order)).to eq(item_1.order_items)
    end
  end
end

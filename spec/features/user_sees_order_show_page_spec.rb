require 'rails_helper'

describe 'As a user' do
  before(:each) do
    @user_1, @user_2 = FactoryBot.create_list(:user, 2)
    @merchant = FactoryBot.create(:merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    @order_1 = @user_1.orders.create(status: 'pending')

    @item_1 = FactoryBot.create(:item)
    @item_2 = FactoryBot.create(:item)

    @order_1.items += [@item_1, @item_2]

    @order_1.order_items.first.update(price: 2, quantity: 3)
    @order_item_1 = @item_1.order_items.first
    @order_1.order_items.last.update(price: 1, quantity: 2)
    @order_item_2 = @item_2.order_items.first

  end
  describe 'when I visit and orders show page' do
    it 'should show the order info and all of the order items' do

      visit profile_order_path(@order_1)

      expect(page).to have_content("Order #{@order_1.id}")
      expect(page).to have_content("Ordered on: #{@order_1.created_at.to_date}")
      expect(page).to have_content("Order updated on: #{@order_1.updated_at.to_date}")
      expect(page).to have_content("Status: #{@order_1.status.titleize}")
      within "#item-#{@item_1.id}" do
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(@item_1.description)
        expect(page).to have_content(@item_1.description)
        expect(page).to have_css("img[src='#{@item_1.image}']")
        expect(page).to have_content("Quantity: 3")

        expect(page).to have_content("Price: $#{@order_item_1.price}")
        expect(page).to have_content("Subtotal: $#{@order_item_1.subtotal}")
      end

      within "#item-#{@item_2.id}" do
        expect(page).to have_content(@item_2.name)
        expect(page).to have_content(@item_2.description)
        expect(page).to have_css("img[src='#{@item_2.image}']")

        expect(page).to have_content("Quantity: 2")

        expect(page).to have_content("Price: $#{@order_item_2.price}")
        expect(page).to have_content("Subtotal: $#{@order_item_2.subtotal}")
      end

      expect(page).to have_content("Grand total: $#{@order_1.total_price}")
    end

    it 'can cancel order if it is still pending' do
      @order_1.order_items.first.update(fulfilled: true)
      item_1_stock_qty_before = @order_1.order_items.first.item.instock_qty
      item_1_order_item_qty = @order_1.order_items.first.quantity
      item_1_expected_qty = item_1_stock_qty_before + item_1_order_item_qty

      item_2_stock_qty_before = @order_1.order_items.last.item.instock_qty
      item_2_expected_qty = item_2_stock_qty_before

      visit profile_order_path(@order_1)

      click_on "| Cancel Order?"

      @order_1.order_items.each do |oi|
        expect(oi.fulfilled).to eq(false)
      end
      expect(@order_1.status).to eq('cancelled')
      item_1_stock_qty_after = Item.find(@order_1.order_items.first.item.id).instock_qty
      expect(item_1_stock_qty_after).to eq(item_1_expected_qty)

      item_2_stock_qty_after =Item.find(@order_1.order_items.last.item.id).instock_qty
      expect(item_2_stock_qty_after).to eq(item_2_expected_qty)

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("Order cancelled")

      within(".order-#{@order_1.id}") do
        expect(page).to have_content("Status: cancelled")
      end
    end
  end
end

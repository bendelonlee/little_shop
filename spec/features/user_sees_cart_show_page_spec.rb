require 'rails_helper'

describe 'as a visitor or registered user' do
  before(:each) do
    @item_1 = FactoryBot.create(:item)
    @item_2 = FactoryBot.create(:item)
    @item_3 = FactoryBot.create(:item)

    visit item_path(@item_1)
    click_button "Add Item"
    visit item_path(@item_1)
    click_button "Add Item"
    visit item_path(@item_2)
    click_button "Add Item"
    visit item_path(@item_3)
    click_button "Add Item"
  end

  describe 'when I have items in my cart' do
    it 'should see all items in cart' do
      visit cart_path

      within(".item-#{@item_1.id}") do
        expect(page).to have_content(@item_1.name)
        expect(page).to have_css("img[src*='#{@item_1.image}']")
        expect(page).to have_content(@item_1.user.name)
        expect(page).to have_content(@item_1.price)
        expect(page).to have_content("Qty 2")
        expect(page).to have_content("Subtotal: $#{@item_1.price * 2}")
      end

      within(".item-#{@item_2.id}") do
        expect(page).to have_content(@item_2.name)
        expect(page).to have_css("img[src*='#{@item_2.image}']")
        expect(page).to have_content(@item_2.user.name)
        expect(page).to have_content(@item_2.price)
        expect(page).to have_content("Qty 1")
        expect(page).to have_content("Subtotal: $#{@item_2.price * 1}")
      end

      within(".item-#{@item_3.id}") do
        expect(page).to have_content(@item_3.name)
        expect(page).to have_css("img[src*='#{@item_3.image}']")
        expect(page).to have_content(@item_3.user.name)
        expect(page).to have_content(@item_3.price)
        expect(page).to have_content("Qty 1")
        expect(page).to have_content("Subtotal: $#{@item_3.price * 1}")
      end

      expect(page).to have_content("Total: $#{@item_1.price * 2 + @item_2.price + @item_3.price}")
    end
    it 'can empty my cart and displays empty cart message' do
      visit cart_path
      click_on "Empty cart"
      expect(current_path).to eq(cart_path)

      # save_and_open_page
      within('nav') do
        expect(page).to have_content('Cart(0)')
      end

      visit cart_path

      expect(page).to have_content("Cart is empty")
      expect(page).to have_no_content("Empty cart")
    end

  end
end

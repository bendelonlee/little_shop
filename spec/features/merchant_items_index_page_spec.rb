require "rails_helper"

describe 'merchant item index page' do
  context "as a merchant" do
    it 'displays my items' do

      merchant = FactoryBot.create(:merchant)
      item_1 = FactoryBot.create(:item)

      item_2 = FactoryBot.create(:item, enabled: false)

      item_2.orders << FactoryBot.create(:fulfilled)
      merchant.items += [item_1, item_2]

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit "/dashboard/items"

      within "#item-#{item_1.id}" do
        expect(page).to have_content("id: #{item_1.id}")
        expect(page).to have_content(item_1.name)
        expect(page).to have_css("img[src='#{item_1.image}']")
        expect(page).to have_content("$#{item_1.price}")
        expect(page).to have_content("In stock: #{item_1.instock_qty}")

        expect(page).to have_button("Edit Item")
        expect(page).to have_button("Delete Item")
        expect(page).to have_button("Disable Item")
        expect(page).to_not have_button("Enable Item")

      end

      within "#item-#{item_2.id}" do
        expect(page).to have_content("id: #{item_2.id}")
        expect(page).to have_content(item_2.name)
        expect(page).to have_css("img[src='#{item_2.image}']")
        expect(page).to have_content("$#{item_2.price}")
        expect(page).to have_content("In stock: #{item_2.instock_qty}")

        expect(page).to have_button("Edit Item")
        expect(page).to_not have_button("Delete Item")
        expect(page).to have_button("Enable Item")

      end
    end

  end
end

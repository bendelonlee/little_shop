require "rails_helper"

describe 'merchant index page' do
  context 'as a visitor' do
    it 'I see active merchants, their city, state and their registration date' do
      merchant_1 = FactoryBot.create(:merchant)
      merchant_2 = FactoryBot.create(:merchant)
      merchant_3 = FactoryBot.create(:merchant, :disabled)

      visit merchants_path

      within "#merchant-#{merchant_1.id}" do
        expect(page).to have_content(merchant_1.name)
        expect(page).to have_content(merchant_1.city)
        expect(page).to have_content(merchant_1.state)
        expect(page).to have_content(merchant_1.created_at.to_date)
      end

      within "#merchant-#{merchant_2.id}" do
        expect(page).to have_content(merchant_2.name)
        expect(page).to have_content(merchant_2.city)
        expect(page).to have_content(merchant_2.state)
        expect(page).to have_content(merchant_2.created_at.to_date)
      end

      expect(page).to_not have_css("#merchant-#{merchant_3.id}")
      expect(page).to_not have_button("Disable")
      expect(page).to_not have_button("Enable")
    end
  end
  context "as an admin" do
    it 'I see merchant info, their names are links, and I see buttons to enable or disable them' do
      admin = FactoryBot.create(:admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      merchant_1 = FactoryBot.create(:merchant)
      merchant_2 = FactoryBot.create(:merchant, :disabled)

      visit merchants_path

      within "#merchant-#{merchant_1.id}" do
        expect(page).to have_content(merchant_1.name)
        expect(page).to have_content(merchant_1.city)
        expect(page).to have_content(merchant_1.state)
        expect(page).to have_content(merchant_1.created_at.to_date)
        expect(page).to have_button("Disable")
      end

      within "#merchant-#{merchant_2.id}" do
        expect(page).to have_content(merchant_2.name)
        expect(page).to have_content(merchant_2.city)
        expect(page).to have_content(merchant_2.state)
        expect(page).to have_content(merchant_2.created_at.to_date)
        expect(page).to have_button("Enable")

      end

    end
  end
end


# As an admin user
# When I visit the merchant's index page at "/merchants"
# I see all merchants in the system
# Next to each merchant's name I see their city and state
# The merchant's name is a link to their Merchant Dashboard at routes such as "/admin/merchants/5"
# I see a "disable" button next to any merchants who are not yet disabled
# I see an "enable" button next to any merchants whose accounts are disabled
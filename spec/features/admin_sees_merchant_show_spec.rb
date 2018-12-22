require 'rails_helper'

describe "as an admin" do
  it "shows the merchant page with the URI /admin/merchants/id" do
    admin = FactoryBot.create(:admin)
    merchant = FactoryBot.create(:merchant)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit merchants_path

    click_on merchant.name

    expect(current_path).to eq(admin_merchant_path(merchant))
    expect(page).to have_content(merchant.name)
    expect(page).to have_content(merchant.email)
    expect(page).to have_content("Pending Orders")
    expect(page).to have_link("View Items")
    #link won't work yet
  end
end
describe "as a visitor" do
  it "does not take me to the admin merchant show page" do
    merchant = FactoryBot.create(:merchant)
    visit admin_merchant_path(merchant)

    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
describe "as a registered user" do
  it "does not take me to the admin merchant show page" do
    user = FactoryBot.create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)


    merchant = FactoryBot.create(:merchant)
    visit admin_merchant_path(merchant)


    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end

require "rails_helper"
describe 'as an admin' do
  before(:each) do
    admin = FactoryBot.create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
  end
  it 'I am redirected from user show to merchant dashboard' do

    merchant = FactoryBot.create(:merchant)
    visit "/admin/users/#{merchant.id}"

    expect(current_path).to eq(admin_merchant_path(merchant))
    expect(page).to have_content("Pending Orders")
    
  end
  it 'I am redirected from merchant dashboard to user show' do

    user = FactoryBot.create(:user)
    visit "/admin/merchants/#{user.id}"

    expect(current_path).to eq(admin_user_path(user))

  end
end

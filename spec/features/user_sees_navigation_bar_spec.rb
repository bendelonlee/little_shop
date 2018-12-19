require 'rails_helper'

describe 'as a visitor' do
  describe 'on the navbar' do
    it 'sees links in the navbar' do
      visit "/"

      within "nav" do
        expect(page).to have_link("Home", href: "/")
        expect(page).to have_link("Browse", href: "/items" )
        expect(page).to have_link("Merchants", href: "/merchants")
        expect(page).to have_content("Cart(0)")
        expect(page).to have_link("Log in", href: "/login")
        expect(page).to have_link("Register", href: "/register")
      end
    end
  end
end

describe 'as a registered user' do
  describe 'on the navbar' do
    it 'sees links in the navbar' do
      user = FactoryBot.create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit "/"

      within "nav" do
        expect(page).to have_link("Home", href: "/")
        expect(page).to have_link("Browse", href: "/items" )
        expect(page).to have_link("Merchants", href: "/merchants")
        expect(page).to have_content("Cart(0)")
        expect(page).to have_link("Profile", href: "/profile")
        expect(page).to have_link("Orders", href: profile_orders_path)
        expect(page).to have_link("Log Out", href: logout_path)
        expect(page).to have_content("Logged in as #{user.name}")
        expect(page).to have_no_link("Log in", href: "/login")
        expect(page).to have_no_link("Register", href: "/register")
      end
    end
  end
end

describe 'as a merchant user' do
  describe 'on the navbar' do
    it 'sees links in the navbar' do
      merchant = FactoryBot.create(:merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit "/"

      within "nav" do
        expect(page).to have_link("Home", href: "/")
        expect(page).to have_link("Browse", href: "/items" )
        expect(page).to have_link("Merchants", href: "/merchants")
        expect(page).to have_link("Orders", href: profile_orders_path)
        expect(page).to have_link("Dashboard", href: "/dashboard")
        expect(page).to have_link("Log Out", href: logout_path)
        expect(page).to have_content("Logged in as #{merchant.name}")
        expect(page).to have_no_link("Cart", href: "/cart")
        expect(page).to have_no_link("Log in", href: "/login")
        expect(page).to have_no_link("Register", href: "/register")
      end
    end
  end
end

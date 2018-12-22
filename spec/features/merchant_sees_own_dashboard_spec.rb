require 'rails_helper'

describe 'As a Merchant' do
  it 'displays the merchants own profile data on the dashboard, but cannot edit' do
    user = FactoryBot.create(:merchant)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/dashboard"

    expect(page).to have_content(user.name)
    expect(page).to have_content(user.email)
    expect(page).to_not have_content(user.password)
    expect(page).to have_content(user.address)
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip_code)
    expect(page).to have_no_link('Edit Profile')
  end

  it 'When I visit my dashboard, I see a link to view my own items. When I click the link it navigates me to /dashboard/items' do
    user = FactoryBot.create(:merchant)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit dashboard_path

    expect(page).to have_link('View Items', href: dashboard_items_path)

  end

  it 'If any users have pending orders containing items I sell, then I see a list of these orders' do
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

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit dashboard_path
    expect(page).to have_link(order_2.id)
    expect(page).to have_content(order_2.created_at)
    expect(page).to have_content("Quantity: #{order_2.total_quantity}")
    expect(page).to have_content(order_2.total_price)

    expect(page).to have_link(order_5.id)
    expect(page).to have_content(order_5.created_at)
    expect(page).to have_content("Quantity: #{order_5.total_quantity}")
    expect(page).to have_content("Price: $#{order_5.total_price}")

    expect(page).to_not have_link(order_1.id)
    expect(page).to_not have_content("Id: #{order_1.id}")

    expect(page).to_not have_link(order_3.id)
    expect(page).to_not have_content("Id: #{order_3.id}")

    expect(page).to_not have_link(order_4.id)
    expect(page).to_not have_content("Id: #{order_4.id}")

    click_on "#{order_2.id}"

    expect(current_path).to eq("/dashboard/orders/#{order_2.id}")
  end

  it 'If the users desired quantity is greater than my current inventory quantity for that item, then I do not see a fulfill button or linkvisit order show page from dashboard, for each item of mine in order, I see' do

  end
end

# USER STORY 61
# As a merchant
# When I visit an order show page from my dashboard
# For each item of mine in the order

# If the user's desired quantity is greater than my current inventory quantity for
# that item, then I do not see a "fulfill" button or link
# Instead I see a big red notice next to the item indicating I cannot fulfill this item

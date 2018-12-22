require 'rails_helper'

describe 'As a Merchant' do
  it 'displays all orders that users have placed on my items' do
    user = FactoryBot.create(:merchant)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/dashboard/orders"

    expect(page)
  end
end


# As a merchant
# When I visit my orders index ("/dashboard/orders")
# I see all orders that users have placed on my items

# Each order listed includes the following information:
#
# the ID of the order, which is a link to the order show page ("/dashboard/orders/15")
# the date the order was made
# the total quantity of my items in the order
# the total value of my items for that order

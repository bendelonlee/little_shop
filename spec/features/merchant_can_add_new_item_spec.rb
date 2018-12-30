require 'rails_helper'


describe 'As a Merchant' do
  before(:each) do
    user = FactoryBot.create(:merchant)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit dashboard_items_path

    click_button 'Add Item'

    expect(current_path).to eq(new_dashboard_item_path)

    fill_in :item_name, with: 'New Item Name'
    fill_in :item_description, with: 'Here is a description of the item.'
    fill_in :item_image, with: 'https://vignette.wikia.nocookie.net/herewestandrp/images/1/1f/New_item.png/revision/latest?cb=20171010214012'
    fill_in :item_price, with: 24
    fill_in :item_instock_qty, with: 35
  end

  it 'Can see a form to add a new item' do

    click_button 'Create Item'

    expect(current_path).to eq(dashboard_items_path)

    expect(page).to have_content("Your new item is saved.")

    item = Item.last
    within "#item-#{item.id}" do
      expect(page).to have_content(item.name)
      expect(page).to have_content(item.description)
      expect(page).to have_css("img[src='#{item.image}']")
      expect(page).to have_content("Price: $#{item.price}")
      expect(page).to have_content("In stock: #{item.instock_qty}")

      expect(page).to have_content("Status: Enabled")
    end
  end

  it 'Form gives errors when name & description field blank' do
    fill_in :item_name, with: ''
    fill_in :item_description, with: ''

    click_button 'Create Item'

    expect(page).to have_content("name can't be blank")
    expect(page).to have_content("description can't be blank")
  end

  it 'Form gives errors when price & instock_qty field blank' do
    fill_in :item_price, with: ''
    fill_in :item_instock_qty, with: ''

    click_button 'Create Item'

    expect(page).to have_content("Item price can't be blank")
    expect(page).to have_content("Item instock_qty can't be blank")
  end
  it 'default image displayed if no image is given' do
    fill_in :item_image, with: ''

    click_button 'Create Item'

    expect(page).to have_css("img[src='/default_image.jpg']")
  end
end

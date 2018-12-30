require "rails_helper"
describe 'as a merchant' do
  before(:each) do
    @new_name = 'New Item Name'
    @new_description = 'Here is a description of the item.'
    @new_image = 'https://vignette.wikia.nocookie.net/herewestandrp/images/1/1f/New_item.png/revision/latest?cb=20171010214012'
    @new_price = 24
    @new_instock_qty = 35

    merchant = FactoryBot.create(:merchant)
    @item = FactoryBot.create(:item, enabled: false, image: "https://some.image")
    merchant.items << @item

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

    visit dashboard_items_path


  end
  it 'I can edit all attributes of an item' do

    within "#item-#{@item.id}" do
      click_on "Edit Item"
    end

    expect(current_path).to eq(edit_dashboard_item_path(@item))

    expect(find_field(:item_name).value).to eq(@item.name)
    expect(find_field(:item_image).value).to eq(@item.image)
    expect(find_field(:item_description).value).to eq(@item.description)
    expect(find_field(:item_price).value).to eq(@item.price.to_s)
    expect(find_field(:item_instock_qty).value).to eq(@item.instock_qty.to_s)

    fill_in :item_name, with: @new_name
    fill_in :item_description, with: @new_description
    fill_in :item_image, with: @new_image
    fill_in :item_price, with: @new_price
    fill_in :item_instock_qty, with: @new_instock_qty

    click_on "Update Item"

    expect(current_path).to eq(dashboard_items_path)

    expect(page).to have_content("Item #{@item.id} '#{@new_name}' has been updated.")

    within "#item-#{@item.id}" do
      expect(page).to have_content(@new_name)
      expect(page).to have_content(@new_description)
      expect(page).to have_css("img[src='#{@new_image}']")
      expect(page).to have_content("$#{@new_price}")
      expect(page).to have_content("In stock: #{@new_instock_qty}")
      expect(page).to have_content("Status: Disabled")
    end

  end
  it 'if I edit an item incorrectly, it gives me errors' do

    within "#item-#{@item.id}" do
      click_on "Edit Item"
    end

    fill_in :item_name, with: ""
    fill_in :item_description, with: ""
    fill_in :item_price, with: -10.99
    fill_in :item_instock_qty, with: 0.1

    click_on "Update Item"
    expect(page).to have_content("Item price must be greater than 0.")
    expect(page).to have_content("Item instock_qty must be an integer.")
    expect(page).to have_content("Item name can't be blank.")
    expect(page).to have_content("Item description can't be blank.")

    fill_in :item_instock_qty, with: -3

    click_on "Update Item"

    expect(page).to have_content("Item instock_qty must be greater than or equal to 0.")
  end
  it "when editing an item, the image field is blank I haven't added an image" do
    @item.update(image: "/default_image.jpg")

    within "#item-#{@item.id}" do
      click_on "Edit Item"
    end

    expect(find_field(:item_image).value).to eq("")
  end
end

#
#
# As a merchant
# When I visit my items page
# And I click the edit button or link next to any item
# Then I am taken to a form similar to the 'new item' form
# My URI route will be "/dashboard/items/15/edit" (if the item's ID was 15)
# The form is re-populated with all of this item's information
# I can change any information, but all of the rules for adding a new item still apply:
# - name and description cannot be blank
# - price cannot be less than $0.00
# - inventory must be 0 or greater
#
# When I submit the form
# I am taken back to my items page
# I see a flash message indicating my item is updated
# I see the item's new information on the page, and it maintains its previous enabled/disabled state
# If I left the image field blank, I see a placeholder image for the thumbnail

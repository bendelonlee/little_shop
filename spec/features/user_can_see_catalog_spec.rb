require 'rails_helper'

describe 'As any type of user' do
  it 'displays all items' do

    item_1 = FactoryBot.create(:item)
    item_2 = FactoryBot.create(:item)
    visit items_path

    within "#item-#{item_1.id}" do
      expect(page).to have_content(item_1.name)
      expect(page).to have_content(item_1.user.name)
      expect(page).to have_content(item_1.instock_qty)
      expect(page).to have_content(item_1.price)
      expect(page).to have_css("img[src='#{item_1.image}']")
      expect(page).to have_content(item_1.description)
    end

    within "#item-#{item_2.id}" do
      expect(page).to have_content(item_2.name)
      expect(page).to have_content(item_2.user.name)
      expect(page).to have_content(item_2.instock_qty)
      expect(page).to have_content(item_2.price)
      expect(page).to have_css("img[src='#{item_2.image}']")
      expect(page).to have_content(item_2.description)
    end

  end
  it "links to the items show page with the item name" do
    item_1 = FactoryBot.create(:item)

    visit items_path
    within("#item-#{item_1.id}") do
      click_on(item_1.name)
    end
    expect(current_path).to eq(item_path(item_1))
  end

  it "links to the items show page with the item name" do
    item_1 = FactoryBot.create(:item)

    visit items_path
    within "#item-#{item_1.id}" do
      click_on("No Image Available")
    end
    expect(current_path).to eq(item_path(item_1))
  end

  it 'does not show disabled items' do
    item_1 = FactoryBot.create(:item)
    item_2 = FactoryBot.create(:item, enabled: false)

    visit items_path

    expect(page).to_not have_css("#item-#{item_2.id}")
  end

  it 'shows most popular and least popular items' do
    item_1 = FactoryBot.create(:item)
    item_2 = FactoryBot.create(:item)
    item_3 = FactoryBot.create(:item)
    item_4 = FactoryBot.create(:item)
    item_5 = FactoryBot.create(:item)
    item_6 = FactoryBot.create(:item)


    FactoryBot.create_list(:order_item, 3, item: item_6, quantity: 10, fulfilled: true)
    FactoryBot.create_list(:order_item, 2, item: item_4, quantity: 12, fulfilled: true)
    FactoryBot.create_list(:order_item, 1, item: item_2, quantity: 13, fulfilled: true)
    FactoryBot.create_list(:order_item, 2, item: item_1, quantity: 6, fulfilled: true)
    FactoryBot.create_list(:order_item, 1, item: item_3, quantity: 1, fulfilled: true)

    visit items_path

    within "#item-index-statistics" do

      within "#most-popular-items" do
        expect(all("li")[0]).to have_content("#{item_6.name} (30 units sold)")
        expect(all("li")[1]).to have_content(item_4.name)
        expect(all("li")[2]).to have_content(item_2.name)
        expect(all("li")[3]).to have_content(item_1.name)
        expect(all("li")[4]).to have_content(item_3.name)

        expect(page).to_not have_content(item_5.name)

      end

      within "#least-popular-items" do
        expect(all("li")[0]).to have_content(item_5.name)
        expect(all("li")[1]).to have_content(item_3.name)
        expect(all("li")[2]).to have_content(item_1.name)
        expect(all("li")[3]).to have_content(item_2.name)
        expect(all("li")[4]).to have_content(item_4.name)
        expect(page).to_not have_content(item_6.name)

      end

    end
  end
end

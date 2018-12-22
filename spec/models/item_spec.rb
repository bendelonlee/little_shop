require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :instock_qty}
    it {should validate_presence_of :price}
    it {should validate_presence_of :description}
  end
  describe 'relationships' do
    it {should belong_to :user}
    it {should have_many :order_items}
    it {should have_many(:orders).through(:order_items)}
  end
  describe 'instance methods' do
    it '.never_ordered?' do
      merchant = FactoryBot.create(:merchant)
      item_1 = FactoryBot.create(:item)
      item_2 = FactoryBot.create(:item)
      item_2.orders << FactoryBot.create(:fulfilled)

      expect(item_1.never_ordered?).to eq(true)
      expect(item_2.never_ordered?).to eq(false)
    end
  end
end

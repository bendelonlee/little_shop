# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

saved_names = "List of current saved login details\n\n"

require "faker"

OrderItem.destroy_all
Item.destroy_all
Order.destroy_all
User.destroy_all

merchants = []
20.times do |merch|
  name = Faker::Name.name
  address = Faker::Address.street_address
  city = Faker::Address.city
  state = Faker::Address.state_abbr
  zip_code = Faker::Address.zip_code
  email = "merchant#{merch}"
  role = 1
  password = 'password'
  saved_names += "Merchant: Email #{email} password '#{password}'\n"
  user = User.create(name: name, address: address, city: city, state: state, zip_code: zip_code, email: email, role: role, password: password, enabled: true)
  merchants << user
  20.times do
    name = Faker::Hipster.word
    instock_qty = rand(0..50)
    price = Faker::Commerce.price
    image = "https://picsum.photos/260/200?image=#{rand(0..1078)}"
    description = Faker::Hipster.sentence
    user.items.create(name: name, instock_qty: instock_qty, price: price, image: image, description: description)
  end
end

20.times do |reg|
  name = Faker::Name.name
  address = Faker::Address.street_address
  city = Faker::Address.city
  state = Faker::Address.state_abbr
  zip_code = Faker::Address.zip_code
  email = "regular#{reg}"
  role = 0
  password = 'password'
  user = User.create(name: name, address: address, city: city, state: state, zip_code: zip_code, email: email, role: role, password: password, enabled: true)
  saved_names += "Normal user: Email #{email} password '#{password}'\n"
  4.times do
    order = user.orders.create!(status: rand(0..2))
    order.items = merchants.sample(1)[0].items.sample(rand(2..8))
    order.order_items.each do |order_item|
      order_item.update({price: order_item.item.price, quantity: (order_item.item.instock_qty/4).round, fulfilled: [true, false].sample})
    end
  end
end

3.times do |adm|
  name = Faker::Name.name
  address = Faker::Address.street_address
  city = Faker::Address.city
  state = Faker::Address.state_abbr
  zip_code = Faker::Address.zip_code
  email = "admin#{adm}"
  role = 2
  password = 'password'
  saved_names += "Admin: Email #{email} password '#{password}'\n"
  user = User.create(name: name, address: address, city: city, state: state, zip_code: zip_code, email: email, role: role, password: password, enabled: true)
end

file_path = './db/saved_login_credentials.txt'
File.open(file_path, 'w') { |file| file.write(saved_names) }

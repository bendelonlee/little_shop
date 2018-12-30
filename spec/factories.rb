FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Lisa#{n}"}
    sequence(:email) { |n| "Lisa#{n}@gmail.com" }
    address {"123 Happy St"}
    city { "Denver" }
    zip_code { 80015 }
    state { 'CO' }
    password { '2738^f' }
    role { 0 }
    enabled { true }
    factory :registered do
      role { 0 }
    end
    factory :merchant do
      role { 1 }
    end
    factory :admin do
      role { 2 }
    end
    trait :disabled do
      enabled { false }
    end
  end

  factory :item do
    association :user, factory: :merchant
    sequence(:name) { |n| "Thing #{n}" }
    sequence(:instock_qty) { |n| 27 + n }
    sequence(:price) { |n| 44 + n }
    image { "/default_image.jpg" }
    sequence(:description) { |n| "this thing is....#{n}" }
    enabled { true }
  end

  factory :order do
    association :user
    status { 0 }
    factory :fulfilled do
      status { 1 }
    end
    factory :pending do
     status { 0 }
    end
    factory :cancelled do
      status { 2 }
    end
  end

  factory :order_item do
    association :order
    association :item
    sequence(:price) { |n| n + 1  }
    sequence(:quantity) { |n| 1 + n }
    fulfilled { false }
  end
end

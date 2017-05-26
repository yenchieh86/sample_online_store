FactoryGirl.define do
  
  sequence(:username) { |n| "TestUser#{n}" }
  sequence(:email) { |n| "TestUser#{n}@example.com" }
  
  factory :user do
    username
    email
    password 'Aa' * 3
    password_confirmation 'Aa' * 3
  end
  
  sequence(:category_title) { |n| "CategoryTitle#{n}" }
  sequence(:category_description) { |n| "CategoryDescription#{n}" }
  
  factory :category do
    title { generate(:category_title) }
    description { generate(:category_description) }
  end
  
  sequence(:item_title) { |n| "ItemTitle#{n}" }
  sequence(:item_description) { |n| "ItemDescription#{n}" }
  
  factory :item do
    title { generate(:item_title) }
    description { generate(:item_description) }
    price '1.11'
    stock 1
    weight '1.11'
    length '1.11'
    width '1.11'
    height '1.11'
    shipping '1.11'
    user nil
    category nil
    sold 0
  end
end
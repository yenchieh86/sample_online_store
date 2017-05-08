FactoryGirl.define do
  
  sequence(:username) { |n| "testuser#{n}" }
  sequence(:email) { |n| "test#{n}@example.com" }
  
  factory :user do
    username
    email
    password '111111'
    password_confirmation '111111'
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
    price "0.00"
    stock 0
    weight "0.00"
    length "0.00"
    width "0.00"
    height "0.00"
    user nil
    category nil
    sold 0
  end
end
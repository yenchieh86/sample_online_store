FactoryGirl.define do
  sequence(:username) { |n| "testuser#{n}" }
  sequence(:email) { |n| "test#{n}@example.com" }
  
  factory :user do
    username
    email
    password '111111'
    password_confirmation '111111'
  end
end
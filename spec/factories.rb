FactoryGirl.define do
  sequence(:email) { |n| "test#{n}@example.com" }
  
  factory :user do
    email
    password '111111'
    password_confirmation '111111'
  end
end
require 'rails_helper'

RSpec.feature 'home' do
  background do
    user = User.create(email: 'test@example.com', password: '111111', password_confirmation: '111111')
    user.confirm
  end
  
  scenario 'user not sign in' do
    visit '/'
    expect(page).to have_text 'TEST'
    expect(page).not_to have_text 'test@example.com'
  end
  
  scenario 'user sign in' do
    visit '/users/sign_in'
    within('#new_user') do
      fill_in 'Email', with: 'test@example.com'
      fill_in 'Password', with: '111111'
    end
    click_button 'Log in'
    expect(page).to have_text 'test@example.com'
    expect(page).not_to have_text 'TEST'
  end
end
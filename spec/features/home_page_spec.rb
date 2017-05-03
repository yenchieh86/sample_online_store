require 'rails_helper'

RSpec.feature 'home' do
  let(:user) { create(:user) }
  background { user.confirm }
  
  scenario 'user not sign in' do
    visit '/'
    expect(page).to have_text 'TEST'
  end
  
  scenario 'user sign in' do
    visit '/users/sign_in'
    
    fill_form(:user, { email: user.email, password: user.password } )
    click_button 'Log in'
    expect(page).to have_text user.email
    expect(page).not_to have_text 'TEST'
  end
end
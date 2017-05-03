require 'rails_helper'

RSpec.feature 'User_authentication' do
  let(:user) { create(:user) }
  background { user.confirm }
  
  feature 'user sign in' do
    let(:user) { create(:user) }
    background { user.confirm }
    
    scenario 'user sign in' do
      home.go
      user_sign_in_page.sign_in(user.email, user.password)
      expect(page).to have_link 'Setting'
      expect(page).to have_link 'Sign Out'
    end
  end
  
  
  private
  
    def home
      PageObjects::Pages::Home.new
    end
    
    def header
      PageObjects::Application::Header.new
    end
    
    def user_sign_in_page
      header.sign_in
    end
end
require 'rails_helper'

RSpec.feature 'home' do
  
  feature 'user not sign in' do
    scenario 'should show sign_in and sign_up' do
      home.go
      expect(page).to have_link 'Sign In'
      expect(page).to have_link 'Sign Up'
    end
    
    scenario 'render user sign_in page' do
      home.go
      header.sign_in
      expect(page).to have_text 'Log in'
    end
  end
  
  
  
  private
  
    def home
      PageObjects::Pages::Home.new
    end
    
    def header
      PageObjects::Application::Header.new
    end
    
    def user_login_page
      PageObjects::Devise::Sessions::New.new
    end
end
require 'rails_helper'

RSpec.feature 'User_signup' do
  
  feature 'user_signup' do
    before { user_signup.sign_up('yenchieh86', 'yenchieh86@hotmail.com', '111111') }
    
    scenario { expect(page).to have_current_path(root_path) }
    
    scenario 'should show specific messages and links' do
      expect(page).to have_css(".bg-success",
                                text: 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.')
      expect(page).to have_link("Yen's Store", href: '/')
      expect(page.body).to include("Welcome to Yen's Shop")
      expect(page).to have_link("Categories List", href: '#')
      expect(page).to have_link('Sign Up', href: new_user_registration_path)
      expect(page).to have_link('Sign In', href: new_user_session_path)
      expect(page).not_to have_link('Sign Out', href: destroy_user_session_path)
      expect(page).not_to have_link('Setting')
      expect(page).not_to have_link('Make the Payment')
    end
    
  end
  
  private
  
    def home
      PageObjects::Pages::Home.new
    end
    
    def header
      PageObjects::Application::Header.new
    end
  
    def user_signup
      home.go
      header.sign_up
    end
end
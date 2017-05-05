require 'rails_helper'

RSpec.feature 'User_signup' do
  scenario 'should send confirmation email after user sign_up' do
    home.go
    expect { user_sign_up_page.sign_up 'test-user', 'test@example.com', '111111' }.to change(ActionMailer::Base.deliveries, :count).by(1)
  end
  
  feature 'wrong informations' do
    scenario "username can't be blank" do
      home.go
      user_sign_up_page.sign_up '', 'test@example.com', '111111'
      expect(page).to have_text "Username can't be blank"
    end
    
    scenario "username can't be too short" do
      home.go
      user_sign_up_page.sign_up 'test', 'test@example.com', '111111'
      expect(page).to have_text "Username is too short (minimum is 6 characters)"
    end
    
    scenario "username can't be too long" do
      home.go
      user_sign_up_page.sign_up ('a' * 21), 'test@example.com', '111111'
      expect(page).to have_text "Username is too long (maximum is 20 characters)"
    end
    
    scenario "username need to be unique" do
      home.go
      user_sign_up_page.sign_up ('a' * 10), 'testa@example.com', '111111'
      home.go
      user_sign_up_page.sign_up ('a' * 10), 'testb@example.com', '111111'
      expect(page).to have_text "Username has already been taken"
    end
    
  end
  
  private
  
    def home
      PageObjects::Pages::Home.new
    end
    
    def header
      PageObjects::Application::Header.new
    end
    
    def user_sign_up_page
      header.sign_up
    end
end
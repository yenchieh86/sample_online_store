require 'rails_helper'

RSpec.feature 'change user information' do
  let(:user) { create(:user) }
  background { user.confirm }
  
  feature 'user_sign_in' do
    background do
      home.go
      log_in.sign_in user.email, '111111'
    end
    
    scenario "username can't be blank" do
      user_setup.update '', user.email, '111111', '111111'
      expect(page).to have_text "Username can't be blank"
    end
    
    scenario "username can't be too short" do
      user_setup.update 'test', user.email, '111111', '111111'
      expect(page).to have_text "Username is too short (minimum is 6 characters)"
    end
    
    scenario "username can't be too long" do
      user_setup.update ('a' * 21), user.email, '111111', '111111'
      expect(page).to have_text "Username is too long (maximum is 20 characters)"
    end
    
  end
  
  
  private
  
    def home
      PageObjects::Pages::Home.new
    end
    
    def header
      PageObjects::Application::Header.new
    end
    
    def log_in
      header.sign_in
    end
    
    def user_setup
      header.user_setup
    end
end
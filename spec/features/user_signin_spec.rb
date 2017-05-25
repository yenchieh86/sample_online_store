require 'rails_helper'

RSpec.feature 'User_sign_in' do
  let!(:user) { create(:user) }
  
  before do
    user.confirm
    log_in.sign_in(user.email, user.password)
  end
  
  scenario { expect(page).to have_current_path(root_path) }
  
  scenario 'should show specific messages and links' do
      expect(page).to have_css(".bg-success", text: 'Signed in successfully.')
      expect(page).to have_link("Yen's Store", href: '/')
      expect(page.body).to include("Hi #{user.username.capitalize}, nice to see you again!")
      expect(page).to have_link("Categories List", href: '#')
      expect(page).to have_link('Sign Out', href: destroy_user_session_path)
      expect(page).to have_link('Setting', href: user_show_path(user))
      expect(page).not_to have_link('Make the Payment', href: user_orders_path(user))
      expect(page).not_to have_link('Sign Up', href: new_user_registration_path)
      expect(page).not_to have_link('Sign In', href: new_user_session_path)
    end

  private
  
    def home
      PageObjects::Pages::Home.new
    end
    
    def header
      PageObjects::Application::Header.new
    end
  
    def log_in
      home.go
      header.sign_in
    end
end
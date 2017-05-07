require 'rails_helper'

RSpec.feature 'home' do
  
  feature 'not signed in user' do
    scenario 'should show sign_in and sign_up' do
      home.go
      expect(page).to have_link 'Sign In', href: new_user_session_path
      expect(page).to have_link 'Sign Up', href: new_user_registration_path
      expect(page).to have_link 'Category List', href: categories_path
    end
    
    scenario 'render user sign_in page' do
      header.sign_in
      expect(page).to have_text 'Log in'
    end
    
    scenario 'should have list of categories' do
      home.go
      expect(page).to have_css '.navbar_list .dropdown-menu'
    end
    
    scenario 'should redirect_to category#show page' do
      category1 = create(:category)
      home.go
      navbar.category_show_page(category1)
      expect(page).to have_text "This is #{category1.title}'s page"
    end
  end
  
  feature 'standard user' do
    let(:user) { create(:user) }
    background do
      user.confirm
      user_login_page.sign_in(user.email, user.password)
    end
    
    scenario 'should show setting and sign_out' do
      home.go
      expect(page).to have_link 'Setting', href: user_show_path(user)
      expect(page).to have_link 'Sign Out', href: destroy_user_session_path
      expect(page).to have_link 'Category List', href: categories_path
    end
  end
  
  private
  
    def home
      PageObjects::Pages::Home.new
    end
    
    def header
      home.go
      PageObjects::Application::Header.new
    end
    
    def user_login_page
      header.sign_in
      PageObjects::Devise::Sessions::New.new
    end
    
    def navbar
      PageObjects::Application::Navbar.new
    end
end
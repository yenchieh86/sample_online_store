require 'rails_helper'

RSpec.feature 'Home_page' do
  
  scenario 'should have specific links' do
    home.go
    expect(page).to have_link 'Sign In', href: new_user_session_path
    expect(page).to have_link 'Sign Up', href: new_user_registration_path
    expect(page).to have_link("Categories List", href: '#')
    expect(page).not_to have_link('Sign Out')
    expect(page).not_to have_link('Setting')
    expect(page).not_to have_link('Make the Payment')
  end
  
  scenario 'should have list of categories' do
    home.go
    expect(page).to have_css '.navbar_list .dropdown-menu'
  end
  
  scenario 'should redirect_to root_url' do
    header.click_logo
    expect(page).to have_current_path(root_path)
  end
  
  private
  
    def home
      PageObjects::Pages::Home.new
    end
    
    def header
      home.go
      PageObjects::Application::Header.new
    end
end
require 'rails_helper'

RSpec.describe "users/show.html.erb", type: :view do
  let(:standard_user) { create(:user) }
  let(:admin) { create(:user) }
  before do
    standard_user.skip_confirmation!
    standard_user.save
    admin.role = 'admin'
    admin.skip_confirmation!
    admin.save
  end
  
  feature 'standard_user' do
    background do
      home.go
      log_in.sign_in standard_user.email, standard_user.password
    end
    
    scenario 'should not show category#new page' do
      user_show_page.go
      expect(page).to have_text standard_user.username
      expect(page).not_to have_link('Add New Category', href: new_category_url)
    end
  end
  
  feature 'admin' do
    background do
      home.go
      log_in.sign_in admin.email, admin.password
    end
    
    scenario 'should show category#new page' do
      user_show_page.go
      expect(page).to have_text admin.username
      expect(page).to have_link 'Add New Category', href: new_category_path
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
    
    def user_show_page
      PageObjects::Pages::UsersShowPage.new
    end 
end

require 'rails_helper'

RSpec.feature 'User_show_page' do
  let!(:standard_user) { create(:user) }
  let!(:admin) { create(:user) }
  
  before do
    standard_user.confirm
    admin.confirm
    admin.update(role: 'admin')
  end
  
  feature 'standard_user' do
    before do
      log_in.sign_in(standard_user.email, standard_user.password)
      show_page.go
    end
    
    scenario { expect(page).to have_current_path(user_show_path(standard_user)) }
    
    scenario 'should show specific messages and links' do
      expect(page).to have_text("This is #{standard_user.username.capitalize}'s show page")
      expect(page).to have_link('Change Account Information', href: edit_user_registration_path)
      expect(page).to have_link('Order List', href: user_orders_path(standard_user))
      expect(page).not_to have_link('User List', href: user_list_path)
      expect(page).not_to have_link('Category List', href: categories_path)
      expect(page).not_to have_link('Add New Category', href: new_category_path)
      expect(page).not_to have_link('Add New Item', href: new_item_path)
      expect(page).not_to have_link('Check Shipping Fee', href: check_shipping_fee_path)
    end
  end
  
  feature 'standard_user' do
    before do
      log_in.sign_in(admin.email, admin.password)
      show_page.go
    end
    
    scenario { expect(page).to have_current_path(user_show_path(admin)) }
    
    scenario 'should show specific messages and links' do
      expect(page).to have_text("This is #{admin.username.capitalize}'s show page")
      expect(page).to have_link('Change Account Information', href: edit_user_registration_path)
      expect(page).to have_link('Order List', href: user_orders_path(admin))
      expect(page).to have_link('User List', href: user_list_path)
      expect(page).to have_link('Category List', href: categories_path)
      expect(page).to have_link('Add New Category', href: new_category_path)
      expect(page).to have_link('Add New Item', href: new_item_path)
      expect(page).to have_link('Check Shipping Fee', href: check_shipping_fee_path)
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
      home.go
      header.sign_in
    end
    
    def show_page
      header.user_setup
    end
end
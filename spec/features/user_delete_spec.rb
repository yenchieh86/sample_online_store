require 'rails_helper'

RSpec.feature 'User_delete' do
  let!(:admin) { build(:user) }
  let!(:backup_user) { build(:user) }
  let!(:order) { Order.create }
  
  
  before do
    admin.role = 'admin'
    admin.save
    admin.confirm
    order.update(user_id: admin.reload.id)
    backup_user.username = 'backup'
    backup_user.role = 'admin'
    backup_user.save
    backup_user.confirm
  end
  
  feature 'before admin delete' do
    scenario 'should not have any order' do
      log_in.sign_in(backup_user.email, backup_user.password)
      order_list_page
      expect(page).not_to have_text 'unpaid'
    end
  end
  
  feature 'after admin delete' do
    
    before do
      log_in.sign_in(admin.email, admin.password)
      user_setpu_page.delete_account
    end
    
    scenario { expect(page).to have_current_path(root_path) }
    
    scenario 'should show specific messages and links' do
      expect(page).to have_css('.bg-success', text: 'Bye! Your account has been successfully cancelled. We hope to see you again soon.')
      expect(page).not_to have_link('Sign Out', href: destroy_user_session_path)
      expect(page).not_to have_link('Setting', href: user_show_path(admin))
      expect(page).not_to have_link('Make the Payment', href: user_orders_path(admin))
      expect(page).to have_link('Sign Up', href: new_user_registration_path)
      expect(page).to have_link('Sign In', href: new_user_session_path)
    end
    
    scenario 'should transfer order to backup_user' do
      log_in.sign_in(backup_user.email, backup_user.password)
      order_list_page
      expect(page).to have_text 'unpaid'
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
    
    def user_show_page
      home.go
      header.user_setup
    end
    
    def user_setpu_page
      user_show_page.update_account_info
    end
    
    def order_list_page
      user_show_page.order_list
    end
end
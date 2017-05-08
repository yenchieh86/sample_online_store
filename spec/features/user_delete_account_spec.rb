require 'rails_helper'

RSpec.feature 'user delete account' do
  
  feature 'admin account' do
    let!(:admin) { build(:user) }
    let!(:backup_user) { User.create(username: 'backup', email: 'backupuser@test.com', password: '111111', password_confirmation: '111111') }
    let!(:category) { create(:category) }
    let!(:item) { build(:item) }
    before do
      admin.skip_confirmation!
      admin.save
      backup_user.skip_confirmation!
      backup_user.save
      item.user_id = admin.reload.id
      item.category_id = category.reload.id
      item.save
    end
    
    scenario 'admin account should be gone' do
      home.go
      log_in.sign_in(admin.email, admin.password)
      expect { user_setup.delete_account }.to change { User.count }.by(-1)
      expect(item.reload.user_id).to eq backup_user.reload.id
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
      user_show_page.update_account_info
    end
    
    def user_show_page
      header.user_setup
    end
end
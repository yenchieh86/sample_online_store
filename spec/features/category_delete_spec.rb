require 'rails_helper'

RSpec.feature 'Category_delete' do
  let!(:admin) { create(:user) }
  let!(:category) { create(:category) }
  let!(:backup_category) { Category.create(title: 'Backup', description: 'backup') }
  let!(:item) { create(:item) }
  
  before do
    admin.confirm
    admin.update(role: 'admin')
    item.update(category_id: category.reload.id)
    log_in.sign_in(admin.email, admin.password)
  end
  
  feature "didn't delete category" do
    scenario 'should show backup_category has 0 item' do
      navbar.category_show_page(backup_category)
      expect(page).not_to have_text(item.title)
    end
  end
  
  feature 'delete category' do
    before do
      category_index.delete(category)
    end
    
    scenario 'should show backup_category has 0 item' do
      navbar.category_show_page(backup_category)
      expect(page).to have_text(item.title)
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
    
    def navbar
      PageObjects::Application::Navbar.new
    end
    
    def user_show
      home.go
      header.user_setup
    end
    
    def category_index
      user_show.category_list
    end
  
end
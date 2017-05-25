require 'rails_helper'

RSpec.feature 'Category_create' do
  
  let!(:admin) { create(:user) }
  
  before do
    admin.confirm
    admin.update(role: 'admin')
    log_in.sign_in(admin.email, admin.password)
  end
  
  feature 'does not have any category' do
    scenario 'should not have any category in the list' do
      expect(page).not_to have_text('Category1')
    end
  end
  
  feature 'have category' do
    before do
      add_new_category.create('Category1', 'Testcategory')
    end
    
    scenario 'should have category in the list' do
      expect(page).to have_text('Category1')
      expect(page).to have_css('.bg-success', text: 'A category has been created.')
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
    
    def add_new_category
      user_show_page.category_new_page
    end
end
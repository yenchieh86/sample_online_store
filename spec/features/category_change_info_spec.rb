require 'rails_helper'

RSpec.feature 'Category_chage_info' do
  
  let!(:admin) { create(:user) }
  
  before do
    admin.confirm
    admin.update(role: 'admin')
    log_in.sign_in(admin.email, admin.password)
    add_new_category.create('Category1', 'Testcategory')
  end
  
  feature 'did not change category info' do
    scenario 'should show old category title' do
      expect(page).to have_text('Category1')
      expect(page).not_to have_text('Category2')
    end
  end
  
  feature 'have category' do
    before do
      category_edit.update('Category2', 'Testcategory')
    end
    
    scenario 'should have category in the list' do
      expect(page).not_to have_text('Category1')
      expect(page).to have_text('Category2')
      expect(page).to have_css('.bg-success', text: "You update the Category2's information.")
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
    
    def category_list
      user_show_page.category_list
    end
    
    def category_edit
      category_list.edit
    end
end
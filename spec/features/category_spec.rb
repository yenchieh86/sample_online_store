require 'rails_helper'

RSpec.feature 'Category' do
  let!(:category) { create(:category) }
  
  describe 'not_signed_in user' do
    it 'should not show likes for create_new_item and edit_category' do
      home.go
      navbar.category_show_page(category)
      expect(page).not_to have_link 'Add New Item'
      expect(page).not_to have_link 'Edit Category Setting'
      expect(page).not_to have_link 'Delete This Category'
    end
  end
  
  describe 'standard_user' do
    let(:user) {create (:user) }
    before do
      user.confirm
      log_in.sign_in(user.email, user.password)
    end
    
    it 'should not show likes for create_new_item and edit_category' do
      home.go
      navbar.category_show_page(category)
      expect(page).not_to have_link 'Add New Item'
      expect(page).not_to have_link 'Edit Category Setting'
      expect(page).not_to have_link 'Delete This Category'
    end
  end
  
  describe 'admin' do
    let(:user) {build (:user) }
    before do
      user.role = 'admin'
      user.save
      user.confirm
      log_in.sign_in(user.email, user.password)
    end
    
    it 'should not show likes for create_new_item, edit_category, and delete' do
      home.go
      navbar.category_show_page(category)
      expect(page).to have_link 'Add New Item'
      expect(page).to have_link 'Edit Category Setting'
      expect(page).to have_link 'Delete This Category'
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
end
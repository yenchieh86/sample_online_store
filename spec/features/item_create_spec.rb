require 'rails_helper'

RSpec.feature 'Item_create' do
  let!(:admin) { create(:user) }
  let!(:category) { create(:category) }
  
  before do
    admin.confirm
    admin.update(role: 'admin')
    log_in.sign_in(admin.email, admin.password)
    @item = { title: 'Item1', description: 'Description1',
                          stock: 1, price: 1.11, weight: 1.11, length: 1.11, 
                          width: 1.11, height: 1.11, shipping: 1.11 }
  end
  
  feature 'did not create item' do
    scenario 'should show category has 0 item' do
      category_index_page
      expect(page).to have_text('0 item')
      expect(page).not_to have_text('1 item')
    end
  end
  
  feature 'created item' do
    before do
      item_new_page.create(category,@item)
    end
    
    scenario 'should show category has 0 item' do
      category_index_page
      expect(page).to have_text('1 item')
      expect(page).not_to have_text('0 item')
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
    
    def category_index_page
      user_show_page.category_list
    end
    
    def item_new_page
      user_show_page.new_item
    end
end
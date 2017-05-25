require 'rails_helper'

RSpec.feature 'Item_change_info' do
  let!(:admin) { create(:user) }
  let!(:category) { create(:category) }
  let!(:item) { create(:item) }
  
  
  before do
    admin.update(role: 'admin')
    admin.confirm
    item.update(user_id: admin.id, category_id: category.id)
    log_in.sign_in(admin.email, admin.password)
  end
  
  feature 'did not change item data' do
    before { navbar.category_show_page(category) }
    
    scenario 'should show old data' do
      expect(page).to have_text(item.title)
      expect(page).not_to have_text('Item1')
    end
  end
  
  feature 'change item title' do
    before do
      @old_title = item.title
      @item = { title: 'Item1', description: 'Description1',
                          stock: 1, price: 1.11, weight: 1.11, length: 1.11, 
                          width: 1.11, height: 1.11, shipping: 1.11 }
      item_edit(category).update(category,@item)
      navbar.category_show_page(category)
    end
    
    scenario 'should show new title' do
      expect(page).to have_text('Item1')
      expect(page).not_to have_text(@old_title)
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
      home.go
      PageObjects::Application::Navbar.new
    end
    
    def user_show
      header.user_setup
    end
    
    def category_list
      user_show.category_list
    end
    
    def item_list(category)
      category_list.show_item(category)
    end
    
    def item_edit(category)
      item_list(category).edit(category.items[0])
    end
    
    
  
end
require 'rails_helper'

RSpec.feature 'Item_delete' do
  let!(:admin) { create(:user) }
  let!(:category) { create(:category) }
  let!(:item) { create(:item) }
  
  
  before do
    admin.update(role: 'admin')
    admin.confirm
    item.update(user_id: admin.id, category_id: category.id)
    log_in.sign_in(admin.email, admin.password)
  end
  
  feature 'did not delete item' do
    before { category_list }
    
    scenario { expect(page).to have_text('1 item') }
    scenario { expect(page).not_to have_text('0 item') }
  end
  
  feature 'delete item' do
    before do
      item_list(category).delete(item)
      category_list
    end
    
    scenario { expect(page).to have_text('0 item') }
    scenario { expect(page).not_to have_text('1 item') }
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
end
require 'rails_helper'

RSpec.feature 'User add shipping_information to order' do
  let!(:user) { create(:user) }
  let!(:category) { create(:category) }
  let!(:item) { create(:item) }
  
  before do
    item.update(category_id: category.id, stock: 3)
    user.confirm
    log_in.sign_in(user.email, user.password)
    select_a_item(category, item).order(2)
    order_list
  end
  
  scenario { expect(page).to have_text 'Create Destination' }
  
  feature 'add shipping_information to order' do
    before do
      @address = { firmname: 'Testuser', address1: '111', address2: '12843 Heritage Pl',
                   city: 'Cerritos', state: 'CA', zip5: '90703', zip4: '6084' }
      create_destination_page(user.orders[0]).create_destination(@address)
    end
    
    scenario 'should show shipping_information' do
      expect(page).to have_text @address[:firmname]
      expect(page).to have_text @address[:address1]
      expect(page).to have_text @address[:address2]
      expect(page).to have_text @address[:city]
      expect(page).to have_text @address[:state]
      expect(page).to have_text @address[:zip5]
      expect(page).to have_text @address[:zip4]
      
      order_list
      expect(page).not_to have_text 'Create Destination'
      expect(page).to have_text 'Show Destination'
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
    
    def select_a_category(category)
      navbar.category_show_page(category)
    end
    
    def select_a_item(category, item)
      select_a_category(category).select_a_item(item)
    end
    
    def order_list
      header.user_setup.order_list
    end
    
    def create_destination_page(order)
      order_list.create_shipping_destination(order)
    end
    
end
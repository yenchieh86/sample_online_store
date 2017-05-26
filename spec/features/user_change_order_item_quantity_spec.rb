require 'rails_helper'

RSpec.feature 'User_change_order_item_quantity' do
  let!(:user) { create(:user) }
  let!(:category) { create(:category) }
  let!(:item) { create(:item) }
  
  before do
    item.update(category_id: category.id, stock: 3)
    user.confirm
    log_in.sign_in(user.email, user.password)
    select_a_item(category, item).order(2)
    home.go
  end
  
  feature 'original data' do
    scenario 'should show correct data' do
      order_list
      
      expect(page).to have_text 'Make the Payment'
      expect(page).to have_text ('unpaid')
      expect(page).to have_css(".order_index table tr.order_id_#{user.orders[0].id} .index", text: '1')
      expect(page).to have_css(".order_index table td.order_item_quantity", text: 1)
      expect(page).to have_css(".order_index table td.order_items_total", text: 2)
      expect(page).to have_css(".order_index table td.shipping", text: item.shipping * 2)
      expect(page).to have_css(".order_index table td.order_total_amount", text: count_total(item, 2))
    end
  end
  
  feature 'change order_item_quantity to 3' do
    scenario 'should chagne order data' do
      order_show(user.orders.first)
      update_quantity(user.orders[0].order_items[0], 3)
      order_list
      
      expect(page).to have_css(".order_index table tr.order_id_#{user.orders[0].id} .index", text: '1')
      expect(page).to have_css(".order_index table td.order_item_quantity", text: 1)
      expect(page).to have_css(".order_index table td.order_items_total", text: 3)
      expect(page).to have_css(".order_index table td.shipping", text: item.shipping * 3)
      expect(page).to have_css(".order_index table td.order_total_amount", text: count_total(item, 3))
    end
  end
  
  feature 'change order_item_quantity to 0' do
    scenario 'should delete the order' do
      order_show(user.orders.first)
      update_quantity(user.orders[0].order_items[0], 0)
      order_list
      
      expect(page).to have_text "You don't have any item in your order list yet"
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
    
    def order_show(order)
      order_list.select_an_order(order)
    end
    
    
    def count_total(item, quantity)
      ((item.shipping + item.price * 1.08) * quantity).round(2)
    end
    
    def update_quantity(order_item, n)
      find("form#edit_order_item_#{order_item.id}").fill_in("order_item_quantity", with: n)
      find("form#edit_order_item_#{order_item.id}").click_button("Change Quantity")
    end
  
  
end
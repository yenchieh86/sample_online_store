require 'rails_helper'

RSpec.feature 'User_put_item_into_shopping_cart' do
  let!(:user) { create(:user) }
  let!(:category) { create(:category) }
  let!(:item) { create(:item) }
  
  before do
    user.confirm
    item.update(category_id: category.id)
    log_in.sign_in(user.email, user.password)
  end
  
  feature 'do not have item in shopping cart' do
    scenario 'should not have Make_the_Payment button in header nav' do
      expect(page).not_to have_text 'Make the Payment'
    end
    
    scenario "should show user doesn't have any item in your order list yet" do
      order_page
      expect(page).to have_text "You don't have any item in your order list yet"
      expect(page).not_to have_text 'unpaid'
    end
  end
  
  feature 'do have item in shopping cart' do
    before do
      select_a_item(category, item).order(1)
      home.go
    end
    
    scenario 'should have Make_the_Payment button in header nav' do
      expect(page).to have_text 'Make the Payment'
    end
    
    scenario "should show user have unpaid order" do
      order_page
      expect(page).not_to have_text "You don't have any item in your order list yet"
      expect(page).to have_text 'unpaid'
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
    
    def order_page
      header.user_setup.order_list
    end
  
end
require 'rails_helper'

RSpec.describe "categories/show.html.erb", type: :view do
  let(:category) { create(:category) }
  
  feature 'no item in category' do
    
    scenario 'should show no item message' do
      category_show_page.go(category)
      expect(page).to have_text "There's no item in this category."
    end
    
  end
  
  feature 'has item in category' do
    let!(:user) { create(:user) }
    before { user.confirm }
    let!(:item) { build(:item) }
    
    scenario 'should not show no item message' do
      item.user_id = user.reload.id
      item.category_id = category.reload.id
      item.save
      category_show_page.go(category)
      expect(page).not_to have_text "There's no item in this category."
    end
    
  end

  private
  
    def category_show_page
      PageObjects::Categories::Show.new
    end
end

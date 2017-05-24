require 'rails_helper'

RSpec.describe 'users/show.html.erb' do
  context 'standard_user' do
    let!(:standard_user) { create(:user) }
    
    before { @user = standard_user }
    
    it 'should show greeting' do
      render
      expect(rendered).to include("This is #{standard_user.username}'s show page")
    end
    
    it 'should show and hide specific tags' do
      render
      expect(rendered).to include("Change Account Information")
      expect(rendered).to include("Order List")
      expect(rendered).not_to include("User List")
      expect(rendered).not_to include("Add New Category")
      expect(rendered).not_to include("Add New Item")
      expect(rendered).not_to include("Check Shipping Fee")
    end
  end
  
  context 'admin' do
    let!(:admin) { build(:user) }
    
    before do
      admin.role = 'admin'
      admin.save
      @user = admin
    end
    
    it 'should show greeting' do
      render
      expect(rendered).to include("This is #{admin.username}'s show page")
    end
    
    it 'should show all tags' do
      render
      expect(rendered).to include("Change Account Information")
      expect(rendered).to include("Order List")
      expect(rendered).to include("User List")
      expect(rendered).to include("Add New Category")
      expect(rendered).to include("Add New Item")
      expect(rendered).to include("Check Shipping Fee")
    end
  end
end
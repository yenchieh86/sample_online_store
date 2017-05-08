require 'rails_helper'

RSpec.describe Item, type: :model do
  let!(:standard_user) { build(:user) }
  let!(:admin) { build(:user) }
  let!(:category) { create(:category) }
  let!(:item) { build(:item) }
  before do
    standard_user.skip_confirmation!
    standard_user.save
    admin.role = 'admin'
    admin.skip_confirmation!
    admin.save
    item.user_id = admin.reload.id
    item.category_id = category.reload.id
  end
  
  describe 'item with valid data' do
    it { expect(item).to be_valid }
  end
  
  describe 'item with not valid data' do
    it 'need to have valid title' do
      item.title = ''
      expect(item).not_to be_valid
      item.title = 'a' * 226
      expect(item).not_to be_valid
    end
    
    it 'should have unique title' do
      item.save
      new_item = build(:item)
      new_item.user_id = admin.reload.id
      new_item.category_id = category.reload.id
      new_item.title = item.title
      expect(new_item).not_to be_valid
    end
    
    
  end

end

require 'rails_helper'

RSpec.describe Item do
  let!(:item) { build(:item) }
  
  context 'not valid data' do
    it 'should not have any symbol in title' do
      array= ['!', '@', '#', '$', '%', '^', '&', '*', ';', '/', '?', '>', '<',
              '=', '+', ')', '(', '_']
      
      for i in 0...array.size
        item.title = 'a' * 6 + array[i]
        expect(item).not_to be_valid
        item.title = array[i] + 'a' * 6
        expect(item).not_to be_valid
        item.title = 'a' * 3 + array[i] + 'a' * 3
        expect(item).not_to be_valid
      end
    end
    
    it 'should not allow to have spave in the beginning or ending of title' do
      item.title = 'aa '
      expect(item).not_to be_valid
      item.title = ' aa'
      expect(item).not_to be_valid
    end
    
    it 'should not allow to have dash in the beginning or ending of title' do
      item.title = 'aa-'
      expect(item).not_to be_valid
      item.title = '-aa'
      expect(item).not_to be_valid
    end
    
    it 'should not have empty title' do
      item.title = ''
      expect(item).not_to be_valid
    end
    
    it 'should not have empty description' do
      item.description = ''
      expect(item).not_to be_valid
    end
    
    it 'should not have title that more than 225 letters' do
      item.title = 'a' * 226
      expect(item).not_to be_valid
    end
    
    it 'should have unique title' do
      item.save
      another_item = build(:item)
      another_item.title = item.title
      expect(another_item).not_to be_valid
    end
    
  end
  
  context 'valid data' do
    it 'should allow to have spave in the middle of title' do
      item.title = 'a a'
      expect(item).to be_valid
    end
    
    it 'should allow to have dash in the middle of title' do
      item.title = 'a-a'
      expect(item).to be_valid
    end
    
    it 'should capitalize the title' do
      item.title.downcase!
      item.save
      expect(item.reload.title).to eq item.title.capitalize
    end
    
    it 'should have status that is default as off_shelf' do
      item.save
      expect(item.reload.status).to eq 'off_shelf'
    end
  end
  
  it { should have_many(:order_items) }
  it { should belong_to(:user) }
  it { should belong_to(:category) }
end
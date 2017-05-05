require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { create(:category) }
  
  context 'correct category info' do
    it 'should create an category' do
      expect { create(:category) }.to change(Category, :count).by 1
    end
    
    it 'should allow to have space in the middle of title' do
      category.title = 'a' * 2 + ' ' + 'a' * 2
      expect(category).to be_valid
    end
  end
  
  context 'wrong category info' do
    it 'should not has null title' do
      category.title = ' '
      expect(category).not_to be_valid
    end
    
    it 'should not has too many letter in title' do
      category.title = 'a' * 226
      expect(category).not_to be_valid
    end
    
    it 'should not has the title that start or end at an space' do
      category.title = ' ' + 'a' * 10
      expect(category).not_to be_valid
      
      category.title = 'a' * 10 + ' '
      expect(category).not_to be_valid
    end
  end
end

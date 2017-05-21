require 'rails_helper'

RSpec.describe Category do
  let!(:category) { build(:category) }
  
  context 'not valid data' do
    it 'should have more than 1 letter in title' do
      category.title = ''
      expect(category).not_to be_valid
    end
    
    it 'should not have more than 225 letter in title' do
      category.title = 'a' * 226
      expect(category).not_to be_valid
    end
    
    it 'should have unique title' do
      category.save
      another_category = build(:category)
      another_category.title = category.title
      expect(another_category).not_to be_valid
    end
    
    it 'should not have dash in the beginning or ending of title' do
      category.title = "-#{category.title}"
      expect(category).not_to be_valid
      category.title = "#{category.title}-"
      expect(category).not_to be_valid
    end
    
    it 'should have more than 1 letter in description' do
      category.description = ''
      expect(category).not_to be_valid
    end
    
    it 'should not have any symbol in title' do
      array= ['!', '@', '#', '$', '%', '^', '&', '*', ';', '/', '?', '>', '<', '=', '+', ')', '(']
      
      for i in 0...array.size
        category.title = 'a' * 6 + array[i]
        expect(category).not_to be_valid
        category.title = array[i] + 'a' * 6
        expect(category).not_to be_valid
        category.title = 'a' * 3 + array[i] + 'a' * 3
        expect(category).not_to be_valid
      end
    end
    
    it 'should not allow to have spave in the beginning or ending of title' do
      category.title = 'aa '
      expect(category).not_to be_valid
      category.title = ' aa'
      expect(category).not_to be_valid
    end
  end
  
  context 'valid data' do
    it 'should allow to have dash in the middle of title' do
      category.title = 'a-a'
      expect(category).to be_valid
    end
    
    it 'should allow to have spave in the middle of title' do
      category.title = 'a a'
      expect(category).to be_valid
    end
    
    it 'should capitalize the title' do
      category.title.downcase!
      category.save
      expect(category.reload.title).to eq category.title.capitalize
    end
  end
  
  it { should have_many (:items) }
end
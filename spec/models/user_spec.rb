require 'rails_helper'

RSpec.describe User do
  let!(:user) { build(:user) }
                
  context 'not valid data' do
    it 'should not has space in username' do
      user.username = 'Test User'
      expect(user).not_to be_valid
    end
    
    it 'should has no less than 6 letter in username' do
      user.username = 'a' * 5
      expect(user).not_to be_valid
    end
    
    it 'should has no more than 20 letter in username' do
      user.username = 'a' * 21
      expect(user).not_to be_valid
    end
    
    it 'should not has symbol letter in username' do
      array= ['!', '@', '#', '$', '%', '^', '&', '*', ';', '/', '?', '>', '<', '=', '+', ')', '(']
      
      for i in 0...array.size
        user.username = 'a' * 6 + array[i]
        expect(user).not_to be_valid
        user.username = array[i] + 'a' * 6
        expect(user).not_to be_valid
        user.username = 'a' * 3 + array[i] + 'a' * 3
        expect(user).not_to be_valid
      end
    end
    
    it 'should has unique username' do
      user.save
      another_user = User.new(username: "#{user.username}", email: 'TestUsera@example.com',
                password: 'Aa' * 3, password_confirmation: 'Aa' * 3 )
      expect(another_user).not_to be_valid
    end
    
    it 'should has unique email' do
      user.save
      another_user = User.new(username: 'TestUsera', email: "#{user.email}",
                password: 'Aa' * 3, password_confirmation: 'Aa' * 3 )
      expect(another_user).not_to be_valid
    end
  end
  
  context 'valid data' do
    before do
      user.skip_confirmation!
      user.save
      user.reload
    end
    
    it 'should turn user username and email into downcase' do
      expect(user.username).to eq user.username.downcase
      expect(user.email).to eq user.email.downcase
    end
    
    it 'should have role that is default as standard' do
      expect(user.role).to eq 'standard'
    end
    
    it 'should recognize both downcase and uppercase for password' do
      expect(user.password).not_to eq 'aa' * 3
      expect(user.password).not_to eq 'AA' * 3
      expect(user.password).to eq 'Aa' * 3
    end
    
    it 'should allow username to have number' do
      new_user = User.new(username: 'TestUsera4', email: 'NewTestUser@example.com',
                password: 'Aa' * 3, password_confirmation: 'Aa' * 3 )
      expect(new_user).to be_valid
    end
    
    it 'should allow username to have dash' do
      new_user = User.new(username: 'Test-Usera', email: 'NewTestUser@example.com',
                password: 'Aa' * 3, password_confirmation: 'Aa' * 3 )
      expect(new_user).to be_valid
    end
  end
  
  it { should have_many(:items) }
  it { should have_many(:orders) }
end
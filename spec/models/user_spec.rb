require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { User.create(username: 'YEN' * 2, email: 'YencHIeH86@HoTmaiL.CoM', password: 'AaA' * 2, password_confirmation: 'AaA' * 2) }
  
  context 'Correct user info' do
    it 'should turn user username and email into downcase' do
      user.reload
      expect(user.username).to eq 'yen' * 2
      expect(user.email).to eq 'yenchieh86@hotmail.com'
    end
    
    it 'should recognize both downcase and uppercase for password' do
      user.reload
      expect(user.password).to eq 'AaA' * 2
    end
    
    it 'should set user role to be standard by default' do
      user.reload
      expect(user.role).to eq 'standard'
    end
  end
  
  context 'wrong user info' do
    it 'should has unique username' do
      another_user = User.create(username: 'YEN' * 2, email: 'test@HoTmaiL.CoM', password: 'AaA' * 2, password_confirmation: 'AaA' * 2)
      expect(another_user).not_to be_valid
    end
    
    it 'should not have space in username format' do
      user.username = '  ' + 'a' * 6
      expect(user).not_to be_valid
      user.username = 'a' * 6 + ' '
      expect(user).not_to be_valid
      user.username = 'a a' * 2
      expect(user).not_to be_valid
    end
    
    it 'should only have number and letter in username' do
      user.username = 'a+' * 6
      expect(user).not_to be_valid
      user.username = 'a/' * 6
      expect(user).not_to be_valid
      user.username = 'a?' * 6
      expect(user).not_to be_valid
      user.username = 'a-' * 6
      expect(user).not_to be_valid
      user.username = 'a_' * 6
      expect(user).not_to be_valid
    end
  end
end
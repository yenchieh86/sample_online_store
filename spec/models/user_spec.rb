require 'rails_helper'

RSpec.describe User, type: :model do
  it 'should turn user username and email into downcase' do
    user = User.create(username: 'YEN' * 2, email: 'YencHIeH86@HoTmaiL.CoM', password: 'AaA' * 2, password_confirmation: 'AaA' * 2)
    user.reload
    expect(user.username).to eq 'yen' * 2
    expect(user.email).to eq 'yenchieh86@hotmail.com'
  end
  
  it 'should recognize both downcase and uppercase for password' do
    user = User.create(username: 'YEN' * 2, email: 'YencHIeH86@HoTmaiL.CoM', password: 'AaA' * 2, password_confirmation: 'AaA' * 2)
    user.reload
    expect(user.password).to eq 'AaA' * 2
  end
end
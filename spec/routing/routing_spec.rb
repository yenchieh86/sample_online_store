require 'rails_helper'

RSpec.describe 'Routing' do
  it 'routes root_path to static_page#home' do
    expect(get: '/').to route_to(controller: 'static_page', action: 'home') 
  end
  
  describe 'user sign_in' do
    before :all do
      user = User.new(username: 'cj4930', email: 'yenchieh86@hotmail.com', password: '111111', password_confirmation: '111111')
      user.skip_confirmation!
      user.save
    end
    
    it 'routes user_show to users#show' do
      expect(get: "/users/show/cj4930").to route_to(controller: 'users', action: 'show', id: 'cj4930')
    end
  end
end
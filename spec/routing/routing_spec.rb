require 'rails_helper'

RSpec.describe 'Routing' do
  it 'routes root_path to static_page#home' do
    expect(get: '/').to route_to(controller: 'static_page', action: 'home') 
  end
end
require 'rails_helper'

RSpec.describe 'layouts/_navbar.html.erb' do
  let!(:category1) { create(:category) }
  let!(:category2) { create(:category) }
  
  it 'should show the list of categories' do
    render
    expect(rendered).to include(category1.title)
    expect(rendered).to include(category2.title)
  end
  
end


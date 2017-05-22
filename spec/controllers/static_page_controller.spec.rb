require 'rails_helper'

RSpec.describe StaticPageController do
  let!(:category_1) { create(:category) }
  let!(:category_2) { create(:category) }
  
  describe 'GET #home' do
    get :home
    
    expect(response.status).to eq 200
    expect(assigns(:categories)).to eq [category_1, category_2]
  end
  
end
require 'rails_helper'

RSpec.describe UsersController do
  let(:standard_user) { create(:user) }
  let(:admin) { create(:user) }
  before do
    standard_user.skip_confirmation!
    standard_user.save
    admin.role = 'admin'
    admin.skip_confirmation!
    admin.save
  end
  
  describe 'not signed in user' do
    it 'should redirect_to sign_in page' do
      get :show, params: { id: standard_user.username }
      expect(response).to redirect_to(new_user_session_url)
    end
    
    it "can't access to users#list page" do
      get :list
      expect(response).to redirect_to(root_url)
    end
  end
  
  describe 'standard_user' do
    it "can't access other user's account information" do
      sign_in standard_user
      get :show, params: { id: admin.username }
      expect(assigns(:user)).to eq standard_user
    end
    
    it 'can access to his own users#show page' do
      sign_in standard_user
      get :show, params: { id: standard_user.username }
      expect(assigns(:user)).to eq standard_user
    end
    
    it "can't access to users#list page" do
      sign_in standard_user
      get :list
      expect(response).to redirect_to(root_url)
    end
  end
  
  describe 'admin' do
    it "can access other user's account information" do
      sign_in admin
      get :show, params: { id: standard_user.username }
      expect(assigns(:user)).to eq standard_user
    end
    
    it 'can access to his own user_show page' do
      sign_in admin
      get :show, params: { id: admin.username }
      expect(assigns(:user)).to eq admin
    end
    
    it "can access to users#list page" do
      user1 = create(:user)
      user2 = create(:user)
      sign_in admin
      get :list
      expect(response).to have_http_status(:success)
      expect(assigns(:users)).to eq User.all
    end
  end
  

end

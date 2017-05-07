require 'rails_helper'

RSpec.describe UsersController do
  let!(:standard_user) { build(:user) }
  let!(:admin) { build(:user) }
  before do
    standard_user.skip_confirmation!
    standard_user.save
    admin.role = 'admin'
    admin.skip_confirmation!
    admin.save
  end
  
  describe 'not signed in user' do
    it 'should redirect_to sign_in page' do
      get :show, params: { id: standard_user.id }
      expect(response).to redirect_to(new_user_session_url)
    end
    
    it "can't access to users#list page" do
      get :list
      expect(response).to redirect_to(root_url)
    end
    
    it "can delete other user" do
      user1 = create(:user)
      expect { delete :erase, params: { id: user1.id } }.to change { User.count }.by(0)
      expect(response).to redirect_to(root_url)
    end
  end
  
  describe 'standard_user' do
    it "can't access other user's account information" do
      sign_in standard_user
      get :show, params: { id: admin.id }
      expect(assigns(:user)).to eq standard_user
    end
    
    it 'can access to his own users#show page' do
      sign_in standard_user
      get :show, params: { id: standard_user.id }
      expect(assigns(:user)).to eq standard_user
    end
    
    it "can't access to users#list page" do
      sign_in standard_user
      get :list
      expect(response).to redirect_to(root_url)
    end
    
    it "can delete other user" do
      user1 = create(:user)
      sign_in standard_user
      expect { delete :erase, params: { id: user1.id } }.to change { User.count }.by(0)
      expect(response).to redirect_to(root_url)
    end
  end
  
  describe 'admin' do
    it "can access other user's account information" do
      sign_in admin
      get :show, params: { id: standard_user.id }
      expect(assigns(:user)).to eq standard_user
    end
    
    it 'can access to his own user_show page' do
      sign_in admin
      get :show, params: { id: admin.id }
      expect(assigns(:user)).to eq admin
    end
    
    it "can access to users#list page" do
      user1 = create(:user)
      sign_in admin
      get :list
      expect(response).to have_http_status(:success)
      expect(assigns(:users).last).to eq(user1)
    end
    
    it "can delete other user" do
      user1 = create(:user)
      sign_in admin
      expect { delete :erase, params: { id: user1.id } }.to change { User.count }.by(-1)
      expect(response).to redirect_to(user_list_url)
    end
    
  end
  

end

=begin


      it "deletes a record" do
        course = create(:course, user: author)
        
        expect { delete :destroy, params: { id: course.id } }.to change { Course.count }.by(-1)
      end
      
      it "redirectes to courses_path" do
        course = create(:course, user: author)
        
        delete :destroy, params: { id: course.id }
        
        expect(response).to redirect_to courses_path
      end
=end
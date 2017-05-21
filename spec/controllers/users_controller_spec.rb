require 'rails_helper'

RSpec.describe UsersController do
  let!(:admin) { build(:user) }
  let!(:standard_user) { build(:user) }
  
  before do
    admin.role = 'admin'
    admin.skip_confirmation!
    admin.save
    standard_user.skip_confirmation!
    standard_user.save
  end
  
  describe 'GET #show' do
    context 'unsigned_in_user' do
      it 'should not be success' do
        get :show, params: { id: standard_user.reload.id }
        expect(response.status).not_to eq 200
      end
      
      it 'should redirect_to new_user_session_url' do
        get :show, params: { id: standard_user.reload.id }
        expect(flash[:alert]).to eq 'Please log in first.'
        expect(response).to redirect_to(new_user_session_url)
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it "should not able to access other user's show page" do
        get :show, params: { id: admin.reload.id }
        expect(response.status).to eq 200
        expect(assigns(:user)).to eq standard_user
      end
      
      it "should able to access it own show page" do
        get :show, params: { id: standard_user.reload.id }
        expect(response.status).to eq 200
        expect(assigns(:user)).to eq standard_user
      end 
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it "should able to access it's own show page" do
        get :show, params: { id: admin.reload.id }
        expect(response.status).to eq 200
        expect(assigns(:user)).to eq admin
      end
      
      it "should able to access other user's show page" do
        get :show, params: { id: standard_user.reload.id }
        expect(response.status).to eq 200
        expect(assigns(:user)).to eq standard_user
      end
    end
  end
  
  describe 'GET #list' do
    context 'unsigned_in_user' do
      it 'should redirect_to new_user_session_url' do
        get :list
        expect(flash[:alert]).to eq 'Please log in first.'
        expect(response).to redirect_to(new_user_session_url)
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it 'should redirect_to root_url' do
        get :list
        expect(flash[:alert]).to eq 'You can not access to user list page.'
        expect(response).to redirect_to(root_url)
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it 'should redirect_to root_url' do
        get :list
        expect(response.status).to eq 200
        expect(assigns(:users)).to eq User.all
      end
    end
  end
  
  describe 'DELETE #erase'do
    let!(:another_user) { create(:user) }
    let!(:item) { build(:item) }
    let!(:backup_user) { build(:user) }
    
    before do
      item.user_id = another_user.id
      item.save
      backup_user.username = 'backup'
      backup_user.skip_confirmation!
      backup_user.save
    end
    
    context 'unsigned_in_user' do
      it "should not able to erase other user's account" do
        expect { delete :erase, params: { id: another_user.reload.id } }.to change { User.count }.by(0)
        expect(flash[:alert]).to eq 'Please sign in first.'
        expect(response).to redirect_to new_user_session_url
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it "should not able to use to this feature" do
        expect { delete :erase, params: { id: another_user.reload.id } }.to change { User.count }.by(0)
        expect(flash[:alert]).to eq "You can't use this feature."
        expect(response).to redirect_to root_url
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it "should able to delete user's account" do
        expect { delete :erase, params: { id: another_user.reload.id } }.to change { User.count }.by(-1)
        expect(flash[:success]).to eq 'You just delete an user.'
        expect(response).to redirect_to user_list_url
      end
      
      it "should let backup_user to take over the user's items" do
        delete :erase, params: { id: another_user.reload.id }
        expect(backup_user.reload.items[0]).to eq item
      end
    end
  end
end
require 'rails_helper'

RSpec.describe CategoriesController do
  let!(:admin) { build(:user) }
  let!(:standard_user) { build(:user) }
  let!(:category_1) { create(:category) }
  let!(:category_2) { create(:category) }
  
  before do
    admin.role = 'admin'
    admin.skip_confirmation!
    admin.save
    standard_user.skip_confirmation!
    standard_user.save
  end
  
  describe 'GET #index' do
    it 'should return all categories' do
      get :index
      expect(response.status).to eq 200
      expect(assigns(:categories)).to eq [category_1, category_2]
    end
  end
  
  describe 'GET #show' do
    it 'should return category target' do
      get :show, params: { id: category_1.reload.id }
      expect(response.status).to eq 200
      expect(assigns(:category)).to eq category_1
    end
  end
  
  describe 'GET #new' do
    context 'unsigned_in_user' do
      it 'should redirect_to new_user_session_url' do
        get :new
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq 'Please sign in first.'
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it 'should redirect_to root_url' do
        get :new
        expect(response).to redirect_to root_url
        expect(flash[:alert]).to eq 'You are not authorized to create new category.'
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it 'should response success' do
        get :new
        expect(response.status).to eq 200
        expect(response).to render_template(:new)
      end
    end
  end
  
  describe 'POST #create' do
    context 'unsigned_in_user' do
      it 'should fail to create new category' do
        expect { post :create, params: { category: { title: 'test', description: 'test' }}}.to change { Category.count }.by(0)
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq 'Please sign in first.'
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it 'should fail to create new category' do
        expect { post :create, params: { category: { title: 'test', description: 'test' }}}.to change { Category.count }.by(0)
        expect(response).to redirect_to root_url
        expect(flash[:alert]).to eq 'You are not authorized to create new category.'
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it 'should created new category' do
        expect { post :create, params: { category: { title: 'test', description: 'test' }}}.to change { Category.count }.by(1)
        expect(response).to redirect_to categories_url
        expect(flash[:success]).to eq 'A category has been created.'
      end
    end
  end
  
  describe 'GET #edit' do
    context 'unsigned_in_user' do
      it 'should redirect_to new_user_session_url' do
        get :edit, params: { id: category_1.reload.id }
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq 'Please sign in first.'
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it 'should redirect_to root_url' do
        get :edit, params: { id: category_1.reload.id }
        expect(response).to redirect_to root_url
        expect(flash[:alert]).to eq 'You are not authorized to create new category.'
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it 'should response success' do
        get :edit, params: { id: category_1.reload.id }
        expect(response.status).to eq 200
        expect(response).to render_template(:edit)
        expect(assigns(:category)).to eq category_1
      end
    end
  end
  
  describe 'PATCH #update' do
    let!(:old_data) { category_1 }
    
    context 'unsigned_in_user' do
      it 'should fail to update category' do
        patch :update, params: { id: category_1.reload.id , category: { title: 'test', description: 'test' }}
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq 'Please sign in first.'
        expect(category_1.reload.title).to eq old_data.title
        expect(category_1.reload.description).to eq old_data.description
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it 'should fail to update category' do
        patch :update, params: { id: category_1.reload.id , category: { title: 'test', description: 'test' }}
        expect(response).to redirect_to root_url
        expect(flash[:alert]).to eq 'You are not authorized to create new category.'
        expect(category_1.reload.title).to eq old_data.title
        expect(category_1.reload.description).to eq old_data.description
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it 'should updated category' do
        patch :update, params: { id: category_1.reload.id , category: { title: 'test', description: 'test' }}
        expect(response).to redirect_to categories_url
        expect(flash[:success]).to eq "You update the #{category_1.reload.title}'s information."
        expect(category_1.reload.title).to eq 'Test'
        expect(category_1.reload.description).to eq 'test'
      end
    end
  end
  
  describe 'DELETE #destroy' do
    let!(:backup_category) { Category.create(title: 'Backup', description: 'test') }
    let!(:item) { build(:item) }
    
    before do
      item.category_id = category_1.reload.id
      item.save
    end
    
    context 'unsigned_in_user' do
      it 'should fail to destroy category' do
        expect { delete :destroy, params: { id: category_1.reload.id } }.to change { Category.count }.by(0)
        expect(flash[:alert]).to eq 'Please sign in first.'
        expect(response).to redirect_to new_user_session_url
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it 'should fail to destroy category' do
        expect { delete :destroy, params: { id: category_1.reload.id } }.to change { Category.count }.by(0)
        expect(flash[:alert]).to eq 'You are not authorized to create new category.'
        expect(response).to redirect_to root_url
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it 'should destroy a category' do
        expect { delete :destroy, params: { id: category_1.reload.id } }.to change { Category.count }.by(-1)
        expect(flash[:success]).to eq 'The category has been deleted'
        expect(response).to redirect_to root_url
      end
      
      it 'should let backup_category take over the items' do
        delete :destroy, params: { id: category_1.reload.id }
        expect(item.reload.category_id).to eq backup_category.reload.id
      end
    end
  end
end
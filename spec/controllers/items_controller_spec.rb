require 'rails_helper'

RSpec.describe ItemsController do
  let!(:standard_user) { build(:user) }
  let!(:admin) { build(:user) }
  let!(:category) { create(:category) }
  let!(:item) { build(:item) }
  
  before do
    standard_user.skip_confirmation!
    standard_user.save
    admin.role = 'admin'
    admin.skip_confirmation!
    admin.save
    item.user_id = admin.id
    item.category_id = category.id
    item.save
  end
  
  describe 'GET #show' do
    it 'should return successfully' do
      get :show, params: { category_id: category.reload.id, id: item.reload.id }
      expect(assigns(:item)).to eq item
      expect(assigns(:order_item)).to be_a_new(OrderItem)
    end
  end
  
  describe 'GET #new' do
    context 'unsigned_in user' do
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
        expect(flash[:alert]).to eq 'You are not authorized to do that.'
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it 'should redirect_to root_url' do
        get :new
        expect(response.status).to eq 200
        expect(response).to render_template(:new)
      end
    end
  end
  
  describe 'POST #create' do
    context 'unsigned_in_user' do
      it 'should redirect_to new_user_session_url' do
        expect { post :create, params: { id: category.reload.id,
                                         item: { title: 'test', description: 'test' } }}.to change { Item.count }.by(0)
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq 'Please sign in first.'
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it 'should redirect_to root_url' do
        expect { post :create, params: { id: category.reload.id,
                                         item: { title: 'test', description: 'test' } }}.to change { Item.count }.by(0)
        expect(response).to redirect_to root_url
        expect(flash[:alert]).to eq 'You are not authorized to do that.'
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it 'should create new item successfully' do
        expect { post :create, params: { id: category.reload.id,
                                         item: { title: 'test', description: 'test', category_id: category.reload.id } }}.to change { Item.count }.by(1)
        expect(response).to redirect_to user_show_url(admin)
        expect(flash[:success]).to eq 'The item was created.'
        expect(assigns(:item).user_id).to eq admin.reload.id
        expect(assigns(:item).category_id).to eq category.reload.id
      end
    end
  end
  
  describe 'GET #edit' do
    context 'unsigned_in_user' do
      it 'should redirect_to new_user_session_url' do
        get :edit, params: { id: item.reload.id }
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq 'Please sign in first.'
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it 'should redirect_to root_url' do
        get :edit, params: { id: item.reload.id }
        expect(response).to redirect_to root_url
        expect(flash[:alert]).to eq 'You are not authorized to do that.'
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it 'should render edit template successfully' do
        get :edit, params: { id: item.reload.id }
        expect(response.status).to eq 200
        expect(response).to render_template(:edit)
      end
    end
  end
  
  describe 'PATCH #update' do
    let!(:new_category) { create(:category)}
    
    context 'unsigned_in_user' do
      it 'should not update item' do
        patch :update, params: { id: item.reload.id, item: { title: 'Test',
                                                             description: 'test',
                                                             category_id: new_category.reload.id }}
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq 'Please sign in first.'
        expect(item.reload.title).not_to eq 'Test'
        expect(item.reload.description).not_to eq 'test'
        expect(item.reload.category_id).not_to eq new_category.reload.id
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it 'should not update item' do
        patch :update, params: { id: item.reload.id, item: { title: 'Test',
                                                             description: 'test',
                                                             category_id: new_category.reload.id }}
        expect(response).to redirect_to root_url
        expect(flash[:alert]).to eq 'You are not authorized to do that.'
        expect(item.reload.title).not_to eq 'Test'
        expect(item.reload.description).not_to eq 'test'
        expect(item.reload.category_id).not_to eq new_category.reload.id
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it 'should update item' do
        patch :update, params: { id: item.reload.id, item: { title: 'Test',
                                                             description: 'test',
                                                             category_id: new_category.reload.id } }
        expect(response).to redirect_to category_item_url(new_category.reload, item.reload)
        expect(flash[:success]).to eq 'The item has been updated'
        expect(item.reload.title).to eq 'Test'
        expect(item.reload.description).to eq 'test'
        expect(item.reload.category_id).to eq new_category.reload.id
      end
    end
  end
  
  describe 'DELETE #destroy' do
    context 'unsigned_in_user' do
      it 'should not delete the item' do
        expect { delete :destroy, params: { id: item.reload.id } }.to change { Item.count }.by(0)
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq 'Please sign in first.'
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it 'should not delete the item' do
        expect { delete :destroy, params: { id: item.reload.id } }.to change { Item.count }.by(0)
        expect(response).to redirect_to root_url
        expect(flash[:alert]).to eq 'You are not authorized to do that.'
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it 'should delete the item' do
        expect { delete :destroy, params: { id: item.reload.id } }.to change { Item.count }.by(-1)
        expect(response).to redirect_to user_show_url(admin)
        expect(flash[:success]).to eq 'Item has been destroyed.'
      end
    end
  end
end 
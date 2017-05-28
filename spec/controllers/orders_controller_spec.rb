require 'rails_helper'

RSpec.describe OrdersController do
  let!(:standard_user) { build(:user) }
  let!(:admin) { build(:user) }
  let!(:standard_user_order) { Order.new }
  let!(:admin_order) { Order.new }
  
  before do
    standard_user.skip_confirmation!
    standard_user.save
    admin.role = 'admin'
    admin.skip_confirmation!
    admin.save
    standard_user_order.user_id = standard_user.reload.id
    standard_user_order.save
    admin_order.user_id = admin.reload.id
    admin_order.save
  end
  
  describe 'GET #index' do
    context 'unsigned_in_user' do
      it 'should not show order list' do
        get :index, params: { user_id: standard_user.reload.id }
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq 'You need to sign in or sign up before continuing.'
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it 'should return successfully'  do
        get :index, params: { user_id: standard_user.reload.id }
        expect(response.status).to eq 200
        expect(response).to render_template(:index)
        expect(assigns(:user)).to eq standard_user
      end
      
      it 'should only show orders that it owned'  do
        get :index, params: { user_id: admin.reload.id }
        expect(response.status).to eq 200
        expect(response).to render_template(:index)
        expect(assigns(:user)).to eq standard_user
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it 'should return successfully'  do
        get :index, params: { user_id: admin.reload.id }
        expect(response.status).to eq 200
        expect(response).to render_template(:index)
        expect(assigns(:user)).to eq admin
      end
      
      it "should able to show other user's orders"  do
        get :index, params: { user_id: standard_user.reload.id }
        expect(response.status).to eq 200
        expect(response).to render_template(:index)
        expect(assigns(:user)).to eq standard_user
      end
    end
  end
  
  describe 'GET #show' do
    context 'unsigned_in_user' do
      it 'should redirect_to new_user_session_url' do
        get :show, params: { id: standard_user }
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq 'You need to sign in or sign up before continuing.'
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it "should able to access it's own order" do
        get :show, params: { id: standard_user_order.reload.id }
        expect(assigns(:order).user_id).to eq standard_user.reload.id
        expect(response).to render_template(:show)
        expect(response.status).to eq 200
      end
      
      it "should not able to access other user's order" do
        get :show, params: { id: admin_order.reload.id }
        expect(response).to redirect_to user_show_url(standard_user)
        expect(flash[:alert]).to eq "You can't access to other user's order."
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it "should able to access it's own order" do
        get :show, params: { id: admin_order.reload.id }
        expect(assigns(:order).user_id).to eq admin.reload.id
        expect(response).to render_template(:show)
        expect(response.status).to eq 200
      end
      
      it "should not able to access other user's order" do
        get :show, params: { id: standard_user_order.reload.id }
        expect(assigns(:order).user_id).to eq standard_user.reload.id
        expect(response).to render_template(:show)
        expect(response.status).to eq 200
      end
    end
  end
  
  describe 'PATCH #receive' do
    context 'unsigned_in_user' do
      it 'should redirect_to new_user_session_url' do
        patch :receive, params: { id: standard_user_order.id }
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq 'You need to sign in or sign up before continuing.'
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it "should able to access it's own order" do
        patch :receive, params: { id: standard_user_order.id }
        expect(response).to redirect_to user_orders_path(standard_user)
        expect(flash[:success]).to eq 'Thank you for shopping.'
        expect(standard_user_order.reload.status).to eq 'finished'
      end
      
      it "should not able to access other user's order" do
        patch :receive, params: { id: admin_order.reload.id }
        expect(response).to redirect_to user_show_url(standard_user)
        expect(flash[:alert]).to eq "You can't access to other user's order."
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it "should able to access it's own order" do
        patch :receive, params: { id: admin_order.reload.id }
        expect(response).to redirect_to user_orders_path(admin)
        expect(flash[:success]).to eq 'Thank you for shopping.'
        expect(admin_order.reload.status).to eq 'finished'
      end
      
      it "should not able to access other user's order" do
        patch :receive, params: { id: standard_user_order.reload.id }
        expect(response).to redirect_to user_orders_path(standard_user)
        expect(flash[:success]).to eq 'Thank you for shopping.'
        expect(standard_user_order.reload.status).to eq 'finished'
      end
    end
  end
end
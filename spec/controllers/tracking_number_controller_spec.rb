require 'rails_helper'

RSpec.describe TrackingNumbersController do
  let!(:standard_user) { create(:user) }
  let!(:admin) { create(:user) }
  let!(:standard_user_order) { Order.new }
  let!(:admin_order) { Order.new }
  let!(:standard_user_order_shipping_information) { ShippingInformation.new }
  let!(:admin_order_shipping_information) { ShippingInformation.new }
  
  before do
    standard_user.skip_confirmation!
    standard_user.save
    admin.role = 'admin'
    admin.skip_confirmation!
    admin.save
    standard_user_order.user_id = standard_user.reload.id
    standard_user_order.save
    standard_user_order_shipping_information.order_id = standard_user_order.id
    standard_user_order_shipping_information.save
    admin_order.user_id = admin.reload.id
    admin_order.save
    admin_order_shipping_information.order_id = admin_order.id
    admin_order_shipping_information.save
  end
  
  describe 'GET #show' do
    context 'unsigned_in_user' do
      it 'should redirect_to new_user_session_url' do
        get :show, params: { order_id: standard_user_order.id, id: standard_user_order.shipping_information.id }
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq 'You need to sign in or sign up before continuing.'
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it 'should render successfully' do
        get :show, params: { order_id: standard_user_order.id, id: standard_user_order.shipping_information.id }
        expect(response.status).to eq 200
        expect(assigns(:package_process)).not_to eq nil
      end
      
      it "should not able to access to other's package information" do
        get :show, params: { order_id: admin_order.id, id: admin_order.shipping_information.id }
        expect(response).to redirect_to root_url
        expect(flash[:alert]).to eq 'You are not authorized to do that.'
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it "should able to access to other's package information" do
        get :show, params: { order_id: standard_user_order.id, id: standard_user_order.shipping_information.id }
        expect(response.status).to eq 200
        expect(assigns(:package_process)).not_to eq nil
      end
    end
  end
  
  describe 'GET #new' do
    context 'unsigned_in_user' do
      it 'should redirect_to new_user_session_url' do
        get :new, params: { order_id: standard_user_order.id }
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq 'You need to sign in or sign up before continuing.'
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it 'should not able to access to #new' do
        get :new, params: { order_id: standard_user_order.id }
        expect(response).to redirect_to root_url
        expect(flash[:alert]).to eq 'You are not authorized to do that.'
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it 'should able to access to #new' do
        get :new, params: { order_id: standard_user_order.id }
        expect(response.status).to eq 200
        expect(response).to render_template(:new)
      end
    end
  end
  
  describe 'POST #create' do
    context 'unsigned_in_user' do
      it 'should redirect_to new_user_session_url' do
        post :create, params: { order_id: standard_user_order.id, tracking_number: 'test' }
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq 'You need to sign in or sign up before continuing.'
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it 'should not able to access to #new' do
        post :create, params: { order_id: standard_user_order.id, tracking_number: 'test' }
        expect(response).to redirect_to root_url
        expect(flash[:alert]).to eq 'You are not authorized to do that.'
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it 'should able to access to #new' do
        post :create, params: { order_id: standard_user_order.id, tracking_number: 'test' }
        expect(flash[:success]).to eq 'Now, customer can track this package.'
        expect(standard_user_order_shipping_information.reload.tracking_number).to eq 'test'
        expect(standard_user_order.reload.status).to eq 'unreceived'
        expect(response).to redirect_to user_list_url
      end
    end
  end
  
  describe 'GET #edit' do
    context 'unsigned_in_user' do
      it 'should redirect_to new_user_session_url' do
        get :edit, params: { order_id: standard_user_order.id, id: standard_user_order.shipping_information.id }
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq 'You need to sign in or sign up before continuing.'
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it 'should not able to access to #edit' do
        get :edit, params: { order_id: standard_user_order.id, id: standard_user_order.shipping_information.id }
        expect(response).to redirect_to root_url
        expect(flash[:alert]).to eq 'You are not authorized to do that.'
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it 'should able to access to #edit' do
        get :edit, params: { order_id: standard_user_order.id, id: standard_user_order.shipping_information.id }
        expect(response.status).to eq 200
        expect(response).to render_template(:edit)
      end
    end
  end
  
  describe 'PATCH #update' do
    context 'unsigned_in_user' do
      it 'should redirect_to new_user_session_url' do
        patch :update, params: { order_id: standard_user_order.id, id: standard_user_order.shipping_information.id,
                                 tracking_number: 'test' }
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq 'You need to sign in or sign up before continuing.'
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it 'should not able to access to #new' do
        patch :update, params: { order_id: standard_user_order.id, id: standard_user_order.shipping_information.id,
                                 tracking_number: 'test' }
        expect(response).to redirect_to root_url
        expect(flash[:alert]).to eq 'You are not authorized to do that.'
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it 'should able to access to #new' do
        patch :update, params: { order_id: standard_user_order.id, id: standard_user_order.shipping_information.id,
                                 tracking_number: 'test1' }
        expect(flash[:success]).to eq 'The tracking number has been updated.'
        expect(standard_user_order_shipping_information.reload.tracking_number).to eq 'test1'
        expect(response).to redirect_to user_list_url
      end
    end
  end
end


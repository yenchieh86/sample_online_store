require 'rails_helper'

RSpec.describe ShippingInformationsController do
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
  
  describe 'GET #show' do
    let!(:standard_user_order_shipping_information) { standard_user_order.create_shipping_information! }
    let!(:admin_order_shipping_information) { admin_order.create_shipping_information! }
    
    context 'unsign_in_user' do
      it 'should redirect_to new_user_session_url' do
        get :show, params: { order_id: standard_user_order.id, id: standard_user_order_shipping_information }
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq "You need to sign in or sign up before continuing."
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it "should render successfully" do
        get :show, params: { order_id: standard_user_order.id, id: standard_user_order_shipping_information.id }
        expect(response.status).to eq 200
        expect(assigns(:shipping_information)).to eq standard_user_order_shipping_information
      end
      
      it "should not able to access to other user's shipping_information" do
        get :show, params: { order_id: admin_order.id, id: admin_order_shipping_information.id }
        expect(response).to redirect_to root_url
        expect(flash[:alert]).to eq "You can't access to other user's order information."
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it "should render successfully" do
        get :show, params: { order_id: admin_order.id, id: admin_order_shipping_information.id }
        expect(response.status).to eq 200
        expect(assigns(:shipping_information)).to eq admin_order_shipping_information
      end
      
      it "should able to access to other user's shipping_information" do
        get :show, params: { order_id: standard_user_order.id, id: standard_user_order_shipping_information.id }
        expect(response.status).to eq 200
        expect(assigns(:shipping_information)).to eq standard_user_order_shipping_information
      end
    end
  end
  
  describe 'GET #new' do
    context 'unsign_in_user' do
      it 'should redirect_to new_user_session_url' do
        get :new, params: { order_id: standard_user_order }
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq "You need to sign in or sign up before continuing."
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it "should render successfully" do
        get :new, params: { order_id: standard_user_order.id }
        expect(response.status).to eq 200
      end
      
      it "should not able to access to other user's shipping_information" do
        get :new, params: { order_id: admin_order.id }
        expect(response).to redirect_to root_url
        expect(flash[:alert]).to eq "You can't access to other user's order information."
      end
      
      it 'should not able to access to new shipping_information view if that order already has one' do
        standard_user_order.create_shipping_information!
        
        get :new, params: { order_id: standard_user_order.id }
        expect(response).to redirect_to order_path(standard_user_order)
        expect(flash[:alert]).to eq 'This order already has shipping_information.'
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it "should able to access to other user's shipping_information" do
        get :new, params: { order_id: standard_user_order.id }
        expect(response.status).to eq 200
      end
    end
  end
  
  describe 'POST #create' do
    context 'unsign_in_user' do
      it ' should redirect_to new_user_session_url' do
        expect { post :create, params: { order_id: standard_user_order.id, shipping_information: { firmname: 'Test User',
                                                                                                   address1: 'address1',
                                                                                                   address2: '12843 Heritage Pl',
                                                                                                   city: 'Cerritos',
                                                                                                   state: 'CA',
                                                                                                   zip5: '90703',
                                                                                                   zip4: '' } } }.to change { ShippingInformation.count }.by(0)
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq "You need to sign in or sign up before continuing."
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it "should created new shipping_information" do
        expect { post :create, params: { order_id: standard_user_order.id, shipping_information: { firmname: 'Test User',
                                                                                                   address1: 'address1',
                                                                                                   address2: '12843 Heritage Pl',
                                                                                                   city: 'Cerritos',
                                                                                                   state: 'CA',
                                                                                                   zip5: '90703',
                                                                                                   zip4: '' } } }.to change { ShippingInformation.count }.by(1)
        expect(flash[:success]).to eq 'The address has been saved, please double check before you make the payment.'
        expect(response).to redirect_to order_shipping_information_url(standard_user_order, standard_user_order.shipping_information)
      end
      
      it "should not created new shipping_information if the address is not valid" do
        expect { post :create, params: { order_id: standard_user_order.id, shipping_information: { firmname: 'Test User',
                                                                                                   address1: 'address1',
                                                                                                   address2: 'tt',
                                                                                                   city: 'Cerritos',
                                                                                                   state: 'CA',
                                                                                                   zip5: '90703',
                                                                                                   zip4: '' } } }.to change { ShippingInformation.count }.by(0)
        expect(flash.now[:alert]).to eq 'Address Not Found.  '
        expect(response).to render_template(:new)
        
        # one letter is not match in address2 attribute
        expect { post :create, params: { order_id: standard_user_order.id, shipping_information: { firmname: 'Test User',
                                                                                                   address1: 'address1',
                                                                                                   address2: '12843 Heritige Pl',
                                                                                                   city: 'Cerritos',
                                                                                                   state: 'CA',
                                                                                                   zip5: '90703',
                                                                                                   zip4: '' } } }.to change { ShippingInformation.count }.by(0)
        expect(flash.now[:alert]).to eq 'Address is not match.'
        expect(response).to render_template(:new)
      
        expect { post :create, params: { order_id: standard_user_order.id, shipping_information: { firmname: 'Test User',
                                                                                                   address1: 'address1',
                                                                                                   address2: '12843 Heritage Pl',
                                                                                                   city: 'tt',
                                                                                                   state: 'CA',
                                                                                                   zip5: '90703',
                                                                                                   zip4: '' } } }.to change { ShippingInformation.count }.by(0)
        expect(flash.now[:alert]).to eq 'Invalid City.  '
        expect(response).to render_template(:new)
        
        expect { post :create, params: { order_id: standard_user_order.id, shipping_information: { firmname: 'Test User',
                                                                                                   address1: 'address1',
                                                                                                   address2: '12843 Heritage Pl',
                                                                                                   city: 'Cerritos',
                                                                                                   state: 'tt',
                                                                                                   zip5: '90703',
                                                                                                   zip4: '' } } }.to change { ShippingInformation.count }.by(0)
        expect(flash.now[:alert]).to eq 'Invalid State Code.  '
        expect(response).to render_template(:new)
        
        expect { post :create, params: { order_id: standard_user_order.id, shipping_information: { firmname: 'Test User',
                                                                                                   address1: 'address1',
                                                                                                   address2: '12843 Heritage Pl',
                                                                                                   city: 'Cerritos',
                                                                                                   state: 'CA',
                                                                                                   zip5: '00000',
                                                                                                   zip4: '' } } }.to change { ShippingInformation.count }.by(0)
        expect(flash.now[:alert]).to eq '5 digit Zipcode is not match.'
        expect(response).to render_template(:new)
        
        expect { post :create, params: { order_id: standard_user_order.id, shipping_information: { firmname: 'Test User',
                                                                                                   address1: 'address1',
                                                                                                   address2: '12843 Heritage Pl',
                                                                                                   city: 'Cerritos',
                                                                                                   state: 'CA',
                                                                                                   zip5: '90703',
                                                                                                   zip4: '0000' } } }.to change { ShippingInformation.count }.by(0)
        expect(flash.now[:alert]).to eq '4 digit Zipcode is not match.'
        expect(response).to render_template(:new)
      end
      
      it "should not able to access other user's shipping_information" do
        expect { post :create, params: { order_id: admin_order.id, shipping_information: { firmname: 'Test User',
                                                                                                   address1: 'address1',
                                                                                                   address2: '12843 Heritage Pl',
                                                                                                   city: 'Cerritos',
                                                                                                   state: 'CA',
                                                                                                   zip5: '90703',
                                                                                                   zip4: '' } } }.to change { ShippingInformation.count }.by(0)
        expect(flash[:alert]).to eq "You can't access to other user's order information."
        expect(response).to redirect_to root_url
      end
      
      it "should not able to create shipping_information " do
        expect { post :create, params: { order_id: standard_user_order.id, shipping_information: { firmname: 'Test User',
                                                                                                   address1: 'address1',
                                                                                                   address2: '12843 Heritage Pl',
                                                                                                   city: 'Cerritos',
                                                                                                   state: 'CA',
                                                                                                   zip5: '90703',
                                                                                                   zip4: '' } } }.to change { ShippingInformation.count }.by(1)
        
        expect { post :create, params: { order_id: standard_user_order.id, shipping_information: { firmname: 'Test User',
                                                                                                   address1: 'address1',
                                                                                                   address2: '12843 Heritage Pl',
                                                                                                   city: 'Cerritos',
                                                                                                   state: 'CA',
                                                                                                   zip5: '90703',
                                                                                                   zip4: '' } } }.to change { ShippingInformation.count }.by(0)
        expect(flash[:alert]).to eq "This order already has shipping_information."
        expect(response).to redirect_to order_path(standard_user_order)
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it "should able to create other user's order shipping_information" do
         expect { post :create, params: { order_id: standard_user_order.id, shipping_information: { firmname: 'Test User',
                                                                                                   address1: 'address1',
                                                                                                   address2: '12843 Heritage Pl',
                                                                                                   city: 'Cerritos',
                                                                                                   state: 'CA',
                                                                                                   zip5: '90703',
                                                                                                   zip4: '' } } }.to change { ShippingInformation.count }.by(1)
        expect(flash[:success]).to eq 'The address has been saved, please double check before you make the payment.'
        expect(response).to redirect_to order_shipping_information_url(standard_user_order, standard_user_order.shipping_information)
      end
    end
  end
  
  describe 'GET #edit' do
    let!(:standard_user_order_shipping_information) { standard_user_order.create_shipping_information! }
    let!(:admin_order_shipping_information) { admin_order.create_shipping_information! }
    
    context 'unsign_in_user' do
      it 'should redirect_to new_user_session_url' do
        get :edit, params: { order_id: standard_user_order.id, id: standard_user_order_shipping_information.id }
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq "You need to sign in or sign up before continuing."
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it 'should render successfully' do
        get :edit, params: { order_id: standard_user_order.id, id: standard_user_order_shipping_information.id }
        expect(response).to render_template(:edit)
        expect(response.status).to eq 200
      end
      
      it "should not able to access other user's shipping_information" do
        get :edit, params: { order_id: admin_order.id, id: admin_order_shipping_information.id }
        expect(response).to redirect_to root_url
        expect(flash[:alert]).to eq "You can't access to other user's order information."
      end
      
      it "should not able to access the shipping_information if the order's status is not 'unpaid" do
        standard_user_order.status = 'unshipped'
        standard_user_order.save
        get :edit, params: { order_id: standard_user_order.id, id: standard_user_order_shipping_information.id }
        expect(response).to redirect_to order_url(standard_user_order)
        expect(flash[:alert]).to eq "You can't change this order's destination, please contact us if you have any question."
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it "should able to access to other user's shipping_information" do
        get :edit, params: { order_id: standard_user_order.id, id: standard_user_order_shipping_information.id }
        expect(response).to render_template(:edit)
        expect(response.status).to eq 200
      end
      
      it "should able to access the shipping_information even the order's status is not 'unpaid'" do
        standard_user_order.status = 'unshipped'
        standard_user_order.save
        get :edit, params: { order_id: standard_user_order.id, id: standard_user_order_shipping_information.id }
        expect(response).to render_template(:edit)
        expect(response.status).to eq 200
      end
    end
  end
  
  describe "PATCH #update" do
    let!(:standard_user_order_shipping_information) { standard_user_order.create_shipping_information! }
    let!(:admin_order_shipping_information) { admin_order.create_shipping_information! }
    
    context 'unsign_in_user' do
      it 'should redirect_to new_user_session_url' do
        patch :update, params: { order_id: standard_user_order.id, id: standard_user_order_shipping_information, 
                                 shipping_information: { firmname: 'Test User', address1: 'address1',
                                                         address2: '12843 Heritage Pl', city: 'Cerritos',
                                                         state: 'CA', zip5: '90703', zip4: '' } }
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq "You need to sign in or sign up before continuing."
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it 'should update shipping_information' do
        patch :update, params: { order_id: standard_user_order.id, id: standard_user_order_shipping_information, 
                                 shipping_information: { firmname: 'Test User', address1: 'address1',
                                                         address2: '12843 Heritage Pl', city: 'Cerritos',
                                                         state: 'CA', zip5: '90703', zip4: '6084' } }
        expect(assigns(:shipping_information).firmname).to eq 'Test User'
        expect(assigns(:shipping_information).address1).to eq 'address1'
        expect(assigns(:shipping_information).address2).to eq '12843 Heritage Pl'
        expect(assigns(:shipping_information).city).to eq 'Cerritos'
        expect(assigns(:shipping_information).state).to eq 'CA'
        expect(assigns(:shipping_information).zip5).to eq '90703'
        expect(assigns(:shipping_information).zip4).to eq '6084'
        expect(response).to redirect_to order_shipping_information_url(standard_user_order, standard_user_order_shipping_information)
        expect(flash[:success]).to eq 'The address has been changed, please double check before you make the payment.'
      end
      
      it "should not able to update other user's shipping_information" do
        patch :update, params: { order_id: admin_order.id, id: admin_order_shipping_information, 
                                 shipping_information: { firmname: 'Test User', address1: 'address1',
                                                         address2: '12843 Heritage Pl', city: 'Cerritos',
                                                         state: 'CA', zip5: '90703', zip4: '6084' } }
        expect(flash[:alert]).to eq "You can't access to other user's order information."
        expect(response).to redirect_to root_url
      end
      
      it "should not able to update shipping_information if order status is not 'unpaid'" do
        standard_user_order.status = 'unshipped'
        standard_user_order.save
        patch :update, params: { order_id: standard_user_order.id, id: standard_user_order_shipping_information, 
                                 shipping_information: { firmname: 'Test User', address1: 'address1',
                                                         address2: '12843 Heritage Pl', city: 'Cerritos',
                                                         state: 'CA', zip5: '90703', zip4: '6084' } }
        expect(response).to redirect_to order_url(standard_user_order)
        expect(flash[:alert]).to eq "You can't change this order's destination, please contact us if you have any question."
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it "should able to update other user's shipping_information" do
        patch :update, params: { order_id: standard_user_order.id, id: standard_user_order_shipping_information, 
                                 shipping_information: { firmname: 'Test User', address1: 'address1',
                                                         address2: '12843 Heritage Pl', city: 'Cerritos',
                                                         state: 'CA', zip5: '90703', zip4: '6084' } }
        expect(assigns(:shipping_information).firmname).to eq 'Test User'
        expect(assigns(:shipping_information).address1).to eq 'address1'
        expect(assigns(:shipping_information).address2).to eq '12843 Heritage Pl'
        expect(assigns(:shipping_information).city).to eq 'Cerritos'
        expect(assigns(:shipping_information).state).to eq 'CA'
        expect(assigns(:shipping_information).zip5).to eq '90703'
        expect(assigns(:shipping_information).zip4).to eq '6084'
        expect(response).to redirect_to order_shipping_information_url(standard_user_order, standard_user_order_shipping_information)
        expect(flash[:success]).to eq 'The address has been changed, please double check before you make the payment.'
      end
      
      it "should able to update shipping_information if order status is not 'unpaid'" do
        standard_user_order.status = 'unshipped'
        standard_user_order.save
        patch :update, params: { order_id: standard_user_order.id, id: standard_user_order_shipping_information, 
                                 shipping_information: { firmname: 'Test User', address1: 'address1',
                                                         address2: '12843 Heritage Pl', city: 'Cerritos',
                                                         state: 'CA', zip5: '90703', zip4: '6084' } }
        expect(assigns(:shipping_information).firmname).to eq 'Test User'
        expect(assigns(:shipping_information).address1).to eq 'address1'
        expect(assigns(:shipping_information).address2).to eq '12843 Heritage Pl'
        expect(assigns(:shipping_information).city).to eq 'Cerritos'
        expect(assigns(:shipping_information).state).to eq 'CA'
        expect(assigns(:shipping_information).zip5).to eq '90703'
        expect(assigns(:shipping_information).zip4).to eq '6084'
        expect(response).to redirect_to order_shipping_information_url(standard_user_order, standard_user_order_shipping_information)
        expect(flash[:success]).to eq 'The address has been changed, please double check before you make the payment.'
      end
    end
  end
end
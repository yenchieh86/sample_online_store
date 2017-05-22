require 'rails_helper'

RSpec.describe ChargesController do
  let!(:standard_user) { build(:user) }
  let!(:order) { Order.new }
  
  before do
    standard_user.skip_confirmation!
    standard_user.save
    order.user_id = standard_user.reload.id
    order.save
  end
  
  describe 'GET #new' do
    it 'should redirect_to new_user_session_url' do
      get :new, params: { order_id: order.id }
      expect(response).to redirect_to new_user_session_url
      expect(flash[:alert]).to eq 'You need to sign in or sign up before continuing.'
    end
    
    it "should redirect_to new_order_shipping_information_url if the order doesn't have shipping_information" do
      sign_in standard_user
      get :new, params: { order_id: order.id }
      expect(response).to redirect_to new_order_shipping_information_url(order)
      expect(flash[:notice]).to eq "Please enter the destination"
    end
    
    it "should redirect_to user_orders_url if the order's order_total_amount is 0" do
      sign_in standard_user
      order.order_total_amount = 0.00
      order.save
      order.create_shipping_information!
      get :new, params: { order_id: order.reload.id }
      expect(response).to redirect_to order_url(order)
    end
  end
end


  
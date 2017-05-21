require 'rails_helper'

RSpec.describe OrderItemsController do
  let!(:standard_user) { build(:user) }
  let!(:admin) { build(:user) }
  let!(:standard_user_order) { Order.new }
  let!(:admin_order) { Order.new }
  let!(:category) { create(:category) }
  let!(:item) { build(:item) }
  
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
    item.category_id = category.reload.id
    item.save
  end
  
  describe 'POST #create' do
    context 'unsigned_in_user' do
      it 'should redirect_to new_user_session_url' do
        expect { post :create, params: { item_id: item.reload.id, order_item: { quantity: 1 } } }.to change { OrderItem.count }.by(0)
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq 'You need to sign in or sign up before continuing.'
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it 'should create new order_item' do
        expect { post :create, params: { item_id: item.reload.id, order_item: { quantity: 1 } } }.to change { standard_user_order.order_items.count}.by(1)
        expect(response).to redirect_to category_item_url(category, item)
        expect(flash[:success]).to eq 'You have added it into your cart.'
      end
      
      it 'should have the right data' do
        post :create, params: { item_id: item.reload.id, order_item: { quantity: 2 } }
        
        expect(standard_user_order.reload.order_items.last.item_id).to eq item.id
        expect(standard_user_order.reload.order_items.last.quantity).to eq 2
        expect(standard_user_order.reload.order_items.last.total_weight).to eq item.weight * 2
        expect(standard_user_order.reload.order_items.last.total_amount).to eq item.price * 2
        expect(standard_user_order.reload.order_items.last.total_dimensions).to eq (item.length * item.width * item.height * 2).round(2)
        expect(standard_user_order.reload.order_items.last.shipping).to eq item.shipping * 2
      end
      
      it "should update order's attributes" do
        old_data = { shipping: standard_user_order.shipping, total_weight: standard_user_order.total_weight,
                     order_items_total: standard_user_order.order_items_total, order_total_amount: standard_user_order.order_total_amount,
                     total_dimensions: standard_user_order.total_dimensions }
        
        expect { post :create, params: { item_id: item.reload.id, order_item: { quantity: 1 } } }.to change { standard_user_order.order_items.count}.by(1)
        expect(standard_user_order.reload.shipping).to eq old_data[:shipping] + item.shipping
        expect(standard_user_order.reload.total_weight).to eq old_data[:total_weight] + item.weight
        expect(standard_user_order.reload.order_items_total).to eq old_data[:order_items_total] + item.price
        expect(standard_user_order.reload.order_total_amount).to eq old_data[:order_items_total] + item.price * (1 + standard_user_order.tax)
        expect(standard_user_order.reload.total_dimensions).to eq (item.length * item.width * item.height + old_data[:total_dimensions]).round(2)
      end
    end
  end
  
  describe 'PATCH #update' do
    
    let!(:order_item) { standard_user_order.order_items.new }
    let!(:admin_order_item) { admin_order.order_items.new }
    
    before do
      order_item.item_id = item.id
      order_item.quantity = 1
      order_item.total_weight = item.weight
      order_item.total_amount = item.price
      order_item.total_dimensions = (item.length * item.width * item.height).round(2)
      order_item.shipping = item.shipping
      order_item.save
      
      admin_order_item.item_id = item.id
      admin_order_item.quantity = 1
      admin_order_item.total_weight = item.weight
      admin_order_item.total_amount = item.price
      admin_order_item.total_dimensions = (item.length * item.width * item.height).round(2)
      admin_order_item.shipping = item.shipping
      admin_order_item.save
    end
    
    context 'unsigned_in_user' do
      it 'should redirect_to new_user_session_url' do
        patch :update, params: { id: order_item.reload.id, order_item: { quantity: 2 } }
        
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq 'You need to sign in or sign up before continuing.'
      end
      
      it "should not update order's data" do
        old_data = { total_weight: order_item.total_weight, shipping: order_item.shipping,
                     total_amount: order_item.total_amount, total_dimensions: order_item.total_dimensions }
        
        patch :update, params: { id: order_item.reload.id, order_item: { quantity: 2 } }
        
        expect(order_item.reload.quantity).to eq 1
        expect(order_item.reload.total_weight).to eq old_data[:total_weight]
        expect(order_item.reload.shipping).to eq old_data[:shipping]
        expect(order_item.reload.total_amount).to eq old_data[:total_amount]
        expect(order_item.reload.total_dimensions).to eq old_data[:total_dimensions]
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it 'should update order_item successfully' do
        old_data = { total_weight: order_item.total_weight, shipping: order_item.shipping,
                     total_amount: order_item.total_amount, total_dimensions: order_item.total_dimensions }
        
        patch :update, params: { id: order_item.reload.id, order_item: { quantity: 2 } }
        
        expect(response).to redirect_to order_url(standard_user_order)
        expect(flash[:success]).to eq 'Your order has been updated.'
        expect(order_item.reload.quantity).to eq 2
        expect(order_item.reload.total_weight).to eq 2 * old_data[:total_weight]
        expect(order_item.reload.shipping).to eq 2 * old_data[:shipping]
        expect(order_item.reload.total_amount).to eq 2 * old_data[:total_amount]
        expect(order_item.reload.total_dimensions).to eq 2 * old_data[:total_dimensions]
      end
      
      
      it 'should delete the order_item if order_item quantity is 0' do
        order_item_count = OrderItem.count
        expect { patch :update, params: { id: order_item.reload.id, order_item: { quantity: 0 } } }.to change { standard_user_order.order_items.count }.by(-1)
        expect(OrderItem.count).to eq order_item_count - 1
      end
      
      it "should not able to change other people's order_item" do
        old_data = { total_weight: admin_order_item.total_weight, shipping: admin_order_item.shipping,
                     total_amount: admin_order_item.total_amount, total_dimensions: admin_order_item.total_dimensions }
        
        patch :update, params: { id: admin_order_item.reload.id, order_item: { quantity: 2 } }
        
        expect(response).to redirect_to root_url
        expect(flash[:alert]).to eq "You can't change other user's order."
        expect(admin_order_item.reload.quantity).to eq 1
        expect(admin_order_item.reload.total_weight).to eq old_data[:total_weight]
        expect(admin_order_item.reload.shipping).to eq old_data[:shipping]
        expect(admin_order_item.reload.total_amount).to eq old_data[:total_amount]
        expect(admin_order_item.reload.total_dimensions).to eq old_data[:total_dimensions]
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it "should able to change other user's order data" do
        old_data = { total_weight: order_item.total_weight, shipping: order_item.shipping,
                     total_amount: order_item.total_amount, total_dimensions: order_item.total_dimensions }
        
        patch :update, params: { id: order_item.reload.id, order_item: { quantity: 2 } }
        
        expect(response).to redirect_to order_url(standard_user_order)
        expect(flash[:success]).to eq 'Your order has been updated.'
        expect(order_item.reload.quantity).to eq 2
        expect(order_item.reload.total_weight).to eq 2 * old_data[:total_weight]
        expect(order_item.reload.shipping).to eq 2 * old_data[:shipping]
        expect(order_item.reload.total_amount).to eq 2 * old_data[:total_amount]
        expect(order_item.reload.total_dimensions).to eq 2 * old_data[:total_dimensions]
      end
    end
  end
  
  describe 'DELETE #destroy' do
    let!(:order_item) { standard_user_order.order_items.create }
    let!(:admin_order_item) { admin_order.order_items.create }
    
    context 'unsigned_in_user' do
      it 'should redirect_to new_user_session_url' do
        expect { delete :destroy, params: { id: order_item.reload.id } }.to change { OrderItem.count }.by(0)
        expect(response).to redirect_to new_user_session_url
        expect(flash[:alert]).to eq 'You need to sign in or sign up before continuing.'
      end
    end
    
    context 'standard_user' do
      before { sign_in standard_user }
      
      it 'should destroy the order_item' do
        expect { delete :destroy, params: { id: order_item.reload.id } }.to change { OrderItem.count }.by(-1)
        expect(response).to redirect_to order_url(standard_user_order)
        expect(flash[:success]).to eq 'Order has been updated.'
      end
      
      it 'should redirect_to root_url' do
        expect { delete :destroy, params: { id: admin_order_item.reload.id } }.to change { OrderItem.count }.by(0)
        expect(response).to redirect_to root_url
        expect(flash[:alert]).to eq "You can't change other user's order."
      end
    end
    
    context 'admin' do
      before { sign_in admin }
      
      it "should able to destroy other user's order_item" do
        expect { delete :destroy, params: { id: order_item.reload.id } }.to change { OrderItem.count }.by(-1)
        expect(response).to redirect_to order_url(standard_user_order)
        expect(flash[:success]).to eq 'Order has been updated.'
      end
    end
  end
end
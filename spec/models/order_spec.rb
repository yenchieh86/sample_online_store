require 'rails_helper'

RSpec.describe Order do
  let!(:user) { create(:user) }
  
  it 'should have status that default is unpaid' do
    order = Order.create
    expect(order.status).to eq 'unpaid'
  end
  
  it { should belong_to(:user) }
  it { should have_many(:order_items) }
  it { should have_one(:shipping_information) }
  
end
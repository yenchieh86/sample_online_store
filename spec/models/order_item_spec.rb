require 'rails_helper'

RSpec.describe OrderItem do
  
  it 'should have status that default as unpaid' do
    order_item = OrderItem.create
    expect(order_item.status).to eq 'unpaid'
  end

  it { should belong_to(:order) }
  it { should belong_to(:item) }
end
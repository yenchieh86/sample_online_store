require 'rails_helper'

RSpec.describe ShippingInformation do
  
  it { should belong_to(:order) }
  
end
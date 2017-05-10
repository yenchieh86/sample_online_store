class OrderItem < ApplicationRecord
  belongs_to :order, counter_cache: true
  belongs_to :item, counter_cache: true
  
  enum status: [:unpaid, :paid]
end

class Order < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_many :order_items
  
  enum status: [:unpaid, :unshipped, :unreceived, :finished]
end

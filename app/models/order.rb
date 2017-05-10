class Order < ApplicationRecord
  belongs_to :user, counter_cache: true
  
  enum status: [:unpaid, :unshipped, :unreceived, :finished]
end

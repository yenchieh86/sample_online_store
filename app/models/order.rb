class Order < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_many :order_items
  has_one :shipping_information
  enum status: [:unpaid, :unshipped, :unreceived, :finished]
end
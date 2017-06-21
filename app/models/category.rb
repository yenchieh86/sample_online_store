class Category < ApplicationRecord
  has_many :items
  
  before_validation { title.capitalize! }
  
  validates :title, presence: true, length: { minimum: 1, maximum: 225 }, uniqueness: { case_sensitive: false }
  validates :description, presence: true, length: { minimum: 1 }
  
  extend FriendlyId
  friendly_id :title, use: :slugged
end

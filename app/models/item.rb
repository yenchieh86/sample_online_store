class Item < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :category, counter_cache: true
  
  before_validation { title.capitalize! }
  
  VALID_TITLE_REGEX = %r(\A[A-Z]+[a-z\d\s]+[a-z\d]+\z)
  validates :title, presence: true, length: { minimum: 1, maximum: 225 }, uniqueness: { case_sensitive: false },
                    format: { with: VALID_TITLE_REGEX }
  validates :description, presence: true, length: { minimum: 1 }
  
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  enum status: [:off_shelf, :on_shelf]
end
class Item < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :category, counter_cache: true
  has_many :order_items
  
  mount_uploaders :pictures, PictureUploader
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  before_validation { title.capitalize! }
  validates :title, presence: true, length: { minimum: 1, maximum: 225 }, uniqueness: { case_sensitive: false }
  validates :description, presence: true, length: { minimum: 1 }
  validate :pictures_size
  validate :pictures_number
  
  enum status: [:off_shelf, :on_shelf]
  
  private
  
    def pictures_size
      if pictures.any?
        pictures.each { |pic| errors.add(:pictures, 'each picture should be less than 120KB') if pic.size > 120.kilobyte }
      end
    end
    
    def pictures_number
      if pictures.any?
        errors.add(:pictures, 'only can upload 3 pictures.') if pictures.count > 3
      end
    end
end
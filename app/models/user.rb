class User < ApplicationRecord
  has_many :items
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
         
  before_validation { username.downcase! }
  
  VALID_USERNAME_REGEX = %r(\A[a-z][a-z\d]+\z)
  validates :username, presence: true, length: { minimum: 6, maximum: 20 }, format: { with: VALID_USERNAME_REGEX }, uniqueness: { case_sensitive: false }
  
  extend FriendlyId
  friendly_id :username, use: :slugged
  
  enum role: [:standard, :admin]
end

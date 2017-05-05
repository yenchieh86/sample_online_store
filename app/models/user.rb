class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  
  validates :username, presence: true, length: { minimum: 6, maximum: 20 }, uniqueness: true
  before_validation { username.downcase! }
  extend FriendlyId
  friendly_id :username, use: :slugged
end

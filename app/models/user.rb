class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :comments, dependent: :destroy
  has_many :restaurants, dependent: :destroy
  
  # I believe that devise does the following by default, but just in case...
  before_save { self.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	
	validates :email, presence: true,
						uniqueness: { case_sensitive: false },
						length: { maximum: 105 },
						format: { with: VALID_EMAIL_REGEX }
end

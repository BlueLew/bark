class Restaurant < ApplicationRecord
  belongs_to :user
  has_many :reviews, dependent: :destroy
  has_many_attached :images, dependent: :destroy
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_one_attached :photo
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :user_preferences
  has_many :shopping_preferences, through: :user_preferences
  belongs_to :address
  accepts_nested_attributes_for :address
end

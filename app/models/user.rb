class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { user: 0, moderator: 1, admin: 2 }

  has_many :products, dependent: :destroy
  has_many :comments, dependent: :destroy # Добавь эту строку!
end
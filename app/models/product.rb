class Product < ApplicationRecord
  belongs_to :user

  validates :name, :description, :price, :category, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :comments, length: { maximum: 500 }, allow_blank: true
  after_create :notify_admin

  def notify_admin
    TelegramNotifier.send_new_product(self)
  end
end

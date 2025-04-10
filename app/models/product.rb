class Product < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy

  validates :name, :description, :price, :category_id, presence: true
  validates :price, numericality: { greater_than: 0 }
  
  after_create :notify_admin

  # Для обратной совместимости с существующим кодом
  def category_name
    category.try(:name)
  end

  def self.by_category(category_name)
    joins(:category).where(categories: { name: category_name })
  end

  private

  def notify_admin
    TelegramNotifier.send_new_product(self)
  end
end
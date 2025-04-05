class AddCategoryAndCommentsToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :category, :string
    add_column :products, :comments, :text
  end
end

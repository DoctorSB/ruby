class RemoveCommentsFromProducts < ActiveRecord::Migration[7.2]
  def change
    remove_column :products, :comments, :text
  end
end

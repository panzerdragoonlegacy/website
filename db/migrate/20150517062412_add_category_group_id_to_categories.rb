class AddCategoryGroupIdToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :category_group_id, :integer, null: true
  end
end

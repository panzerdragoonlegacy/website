class AddListViewToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :list_view, :boolean, default: false
  end
end

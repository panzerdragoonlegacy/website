class RemoveCategoryFromNewsEntries < ActiveRecord::Migration[6.0]
  def change
    remove_column :news_entries, :category_id, :integer
    Category.where(category_type: 'news_entry').delete_all
  end
end

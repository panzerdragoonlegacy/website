class AddCategoryToNewsEntries < ActiveRecord::Migration
  def change
    add_column :news_entries, :category_id, :integer
  end
end

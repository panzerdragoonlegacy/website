class RemovePostTypeFromNewsEntries < ActiveRecord::Migration
  def change
    remove_column :news_entries, :link, :string
    remove_column :news_entries, :post_type, :string
  end
end

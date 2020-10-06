class RemoveOldTables < ActiveRecord::Migration[6.0]
  def change
    drop_table :articles
    drop_table :chapters
    drop_table :encyclopaedia_entries
    drop_table :links
    drop_table :poems
    drop_table :special_pages
    drop_table :stories
  end
end

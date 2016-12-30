class AddNewsEntryPictureToNewsEntries < ActiveRecord::Migration
  def change
    add_column :news_entries, :news_entry_picture_file_name, :string
    add_column :news_entries, :news_entry_picture_content_type, :string
    add_column :news_entries, :news_entry_picture_file_size, :integer
    add_column :news_entries, :news_entry_picture_updated_at, :datetime
  end
end

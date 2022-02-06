class RenameEncyclopaediaEntryPicture < ActiveRecord::Migration
  def change
    rename_column :encyclopaedia_entries,
                  :picture_file_name,
                  :encyclopaedia_entry_picture_file_name
    rename_column :encyclopaedia_entries,
                  :picture_content_type,
                  :encyclopaedia_entry_picture_content_type
    rename_column :encyclopaedia_entries,
                  :picture_file_size,
                  :encyclopaedia_entry_picture_file_size
    rename_column :encyclopaedia_entries,
                  :picture_updated_at,
                  :encyclopaedia_entry_picture_updated_at
  end
end

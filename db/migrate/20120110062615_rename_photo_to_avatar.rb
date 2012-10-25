class RenamePhotoToAvatar < ActiveRecord::Migration
  def change
    rename_column :dragoons, :photo_file_name, :avatar_file_name
    rename_column :dragoons, :photo_content_type, :avatar_content_type
    rename_column :dragoons, :photo_file_size, :avatar_file_size
    rename_column :dragoons, :photo_updated_at, :avatar_updated_at
  end
end

class AddAlbumToPictures < ActiveRecord::Migration
  def up
    add_column :pictures, :album_id, :integer
  end

  def down
    remove_column :pictures, :album_id
  end
end

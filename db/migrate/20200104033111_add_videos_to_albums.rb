class AddVideosToAlbums < ActiveRecord::Migration
  def change
    add_column :videos, :source_url, :string
    add_column :videos, :album_id, :integer
  end
end

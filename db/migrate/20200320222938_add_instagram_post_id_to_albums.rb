class AddInstagramPostIdToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :instagram_post_id, :string
  end
end

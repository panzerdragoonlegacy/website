class AddInformationToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :information, :text
  end
end

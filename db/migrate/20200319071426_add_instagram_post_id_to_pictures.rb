class AddInstagramPostIdToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :instagram_post_id, :string
  end
end

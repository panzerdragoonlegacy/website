class AddIdOfPictureToReplaceToPictures < ActiveRecord::Migration
  def up
    add_column :pictures, :id_of_picture_to_replace, :integer
  end

  def down
    remove_column :pictures, :id_of_picture_to_replace
  end
end

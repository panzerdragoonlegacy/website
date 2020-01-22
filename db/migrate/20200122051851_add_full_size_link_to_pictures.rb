class AddFullSizeLinkToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :full_size_link, :boolean, default: true
  end
end

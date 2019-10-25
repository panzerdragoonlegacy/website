class AddSourceUrlToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :source_url, :string
  end
end

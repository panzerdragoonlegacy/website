class AddControversialContentToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :controversial_content, :boolean, default: false
  end
end

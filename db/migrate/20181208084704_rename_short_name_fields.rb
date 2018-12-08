class RenameShortNameFields < ActiveRecord::Migration
  def change
    rename_column :categories, :short_name, :short_name_for_saga
    rename_column :categories, :short_name_2, :short_name_for_media_type
  end
end

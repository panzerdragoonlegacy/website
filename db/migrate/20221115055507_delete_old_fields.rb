class DeleteOldFields < ActiveRecord::Migration[7.0]
  def up
    remove_column :albums, :url
    remove_column :categories, :url

    remove_column :categories, :category_group_id
    remove_column :categories, :saga_id
    remove_column :categories, :short_name_for_saga
    remove_column :categories, :short_name_for_media_type

    remove_column :contributor_profiles, :url
    remove_column :downloads, :url
    remove_column :music_tracks, :url
    remove_column :news_entries, :url
    remove_column :pages, :url

    remove_column :pages, :old_model_id
    remove_column :pages, :old_model_type

    remove_column :pictures, :url
    remove_column :tags, :url
    remove_column :videos, :url
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

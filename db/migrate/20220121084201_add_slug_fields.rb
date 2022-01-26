class AddSlugFields < ActiveRecord::Migration[7.0]
  def change
    add_column :albums, :slug, :string
    add_column :category_groups, :slug, :string
    add_column :categories, :slug, :string
    add_column :contributor_profiles, :slug, :string
    add_column :downloads, :slug, :string
    add_column :music_tracks, :slug, :string
    add_column :news_entries, :slug, :string
    add_column :pages, :slug, :string
    add_column :pictures, :slug, :string
    add_column :quizzes, :slug, :string
    add_column :sagas, :slug, :string
    add_column :tags, :slug, :string
    add_column :videos, :slug, :string
  end
end

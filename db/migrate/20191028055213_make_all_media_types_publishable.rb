class MakeAllMediaTypesPublishable < ActiveRecord::Migration
  def change
    add_column :encyclopaedia_entries, :published_at, :datetime
    add_column :articles, :published_at, :datetime
    add_column :downloads, :published_at, :datetime
    add_column :music_tracks, :published_at, :datetime
    add_column :pictures, :published_at, :datetime
    add_column :poems, :published_at, :datetime
    add_column :quizzes, :published_at, :datetime
    add_column :resources, :published_at, :datetime
    add_column :stories, :published_at, :datetime
    add_column :videos, :published_at, :datetime
    add_column :albums, :published_at, :datetime
    add_column :contributor_profiles, :published_at, :datetime
    add_column :categories, :published_at, :datetime
    add_column :special_pages, :published_at, :datetime

    models = [
      EncyclopaediaEntry,
      Article,
      Download,
      MusicTrack,
      Picture,
      Poem,
      Quiz,
      Resource,
      Story,
      Video,
      Album,
      ContributorProfile,
      Category,
      SpecialPage
    ]
    models.each do |model|
      model.all.each do |record|
        if record.published_at.blank? && record.publish
          record.published_at = record.created_at
          record.save
        end
      end
    end
  end
end

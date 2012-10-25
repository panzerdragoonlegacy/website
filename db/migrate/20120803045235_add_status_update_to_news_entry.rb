class AddStatusUpdateToNewsEntry < ActiveRecord::Migration
  def change
    add_column :news_entries, :published_at, :datetime
    add_column :news_entries, :status_update, :string
    add_column :news_entries, :short_url, :string
    add_column :news_entries, :publish, :boolean
    NewsEntry.reset_column_information
    NewsEntry.all.each do |news_entry|
      news_entry.published_at = news_entry.created_at
      news_entry.publish = true
      news_entry.save
    end
  end
end

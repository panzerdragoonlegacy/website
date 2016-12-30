class RemoveShortUrlFromNewsEntries < ActiveRecord::Migration
  def up
    remove_column :news_entries, :short_url
  end

  def down
    add_column :news_entries, :short_url, :string
  end
end

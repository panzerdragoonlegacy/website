class AddPostTypeToNewsEntries < ActiveRecord::Migration
  def change
    add_column :news_entries, :link, :string
    add_column :news_entries, :post_type, :string

    NewsEntry.all.each do |news_entry|
      news_entry.post_type = :news.to_s
      news_entry.save
    end
  end
end

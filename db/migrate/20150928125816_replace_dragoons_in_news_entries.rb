class ReplaceDragoonsInNewsEntries < ActiveRecord::Migration
  def up
    NewsEntry.all.each do |news_entry|
      news_entry.content.gsub!(%r{\(\/dragoons}, '(/contributors')
      news_entry.save
    end
  end

  def down
    NewsEntry.all.each do |news_entry|
      news_entry.content.gsub!(%r{\(\/contributors}, '(/dragoons')
      news_entry.save
    end
  end
end

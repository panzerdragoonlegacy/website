atom_feed do |feed|
  feed.title 'Panzer Dragoon Legacy'
  feed.updated @news_entries.first.created_at

  @news_entries.each do |news_entry|
    feed.entry(news_entry) do |entry|
      entry.title(news_entry.name)
      entry.content(
        news_entry_markdown_to_html(news_entry.content),
        type: 'html'
      )
      entry.author { |author| author.name news_entry.contributor_profile.name }
    end
  end
end

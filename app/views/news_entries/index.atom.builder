atom_feed do |feed|
  feed.title("The Will of the Ancients")
  feed.updated(@news_entries.first.created_at)

  @news_entries.each do |news_entry|
    feed.entry(news_entry) do |entry|
      entry.title(news_entry.name)
      entry.content(news_entry_markdown_to_html(news_entry.content),
        type: 'html')
      entry.author do |author|
        author.name(news_entry.contributor_profile.name)
      end
    end
  end
end

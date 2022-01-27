class AddAlternativeSlugToNewsEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :news_entries, :alternative_slug, :string

    # Copy url field to alternative slug if it is different from the slug.
    NewsEntry.all.each do |news_entry|
      if news_entry.url != news_entry.slug
        puts "Setting alternative slug for news entry:"
        puts "#{news_entry.id} #{news_entry.name}"
        news_entry.alternative_slug = news_entry.url
        puts "Alternative slug: #{news_entry.alternative_slug}"
        news_entry.save!
      end
    end
  end
end

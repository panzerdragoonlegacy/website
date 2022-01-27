class AddAlternativeSlugToNewsEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :news_entries, :alternative_slug, :string
  end
end

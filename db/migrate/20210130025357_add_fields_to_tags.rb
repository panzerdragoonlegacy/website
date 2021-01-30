class AddFieldsToTags < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :information, :text
    add_column :tags, :wiki_slug, :string
  end
end

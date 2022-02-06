class CreateTagsAgain < ActiveRecord::Migration
  def up
    create_table :tags do |t|
      t.string :name
      t.string :url
      t.string :description
      t.timestamps
    end

    encyclopaedia_entries = EncyclopaediaEntry.all
    encyclopaedia_entries.each do |encyclopaedia_entry|
      Tag.create(name: encyclopaedia_entry.name)
    end
  end

  def down
    drop_table :tags
  end
end

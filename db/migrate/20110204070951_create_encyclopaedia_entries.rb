class CreateEncyclopaediaEntries < ActiveRecord::Migration
  def self.up
    create_table :encyclopaedia_entries do |t|
      t.string :name
      t.string :url
      t.text :information
      t.text :content
      t.string :picture_file_name
      t.string :picture_content_type
      t.integer :picture_file_size
      t.datetime :picture_updated_at
      t.boolean :publish
      t.references :category
      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end

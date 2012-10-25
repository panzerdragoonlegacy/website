class CreateNewsEntries < ActiveRecord::Migration
  def self.up
    create_table :news_entries do |t|
      t.string :name
      t.string :url
      t.text :content
      t.references :dragoon
      t.timestamps
    end
  end

  def self.down
    drop_table :news_entries
  end
end

class CreateChapters < ActiveRecord::Migration
  def self.up
    create_table :chapters do |t|
      t.integer :story_id
      t.string :chapter_type, default: 'regular_chapter'
      t.integer :number, default: 1
      t.string :name
      t.string :url
      t.text :content
      t.boolean :publish
      t.timestamps
    end
  end

  def self.down
    drop_table :chapters
  end
end

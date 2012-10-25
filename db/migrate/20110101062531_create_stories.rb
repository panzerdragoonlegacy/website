class CreateStories < ActiveRecord::Migration
  def self.up
    create_table :stories do |t|
      t.string :name
      t.string :url
      t.string :description
      t.text :content
      t.boolean :publish
      t.timestamps
    end
  end

  def self.down
    drop_table :stories
  end
end

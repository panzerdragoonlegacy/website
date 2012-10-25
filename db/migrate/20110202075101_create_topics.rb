class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.string :subject
      t.string :url
      t.text :message
      t.references :dragoon
      t.references :project
      t.timestamps
    end
  end

  def self.down
    drop_table :topics
  end
end

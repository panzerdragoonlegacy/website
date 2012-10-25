class CreateDiscussions < ActiveRecord::Migration
  def self.up
    create_table :discussions do |t|
      t.string :subject
      t.string :url
      t.text :message
      t.references :category
      t.references :dragoon
      t.timestamps
    end
  end

  def self.down
    drop_table :discussions
  end
end

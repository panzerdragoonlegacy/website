class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :message
      t.references :commentable, polymorphic: true
      t.references :dragoon
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end

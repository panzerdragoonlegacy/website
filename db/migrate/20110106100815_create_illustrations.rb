class CreateIllustrations < ActiveRecord::Migration
  def self.up
    create_table :illustrations do |t|
      t.integer :illustratable_id
      t.string :illustratable_type
      t.string :illustration_file_name
      t.string :illustration_content_type
      t.integer :illustration_file_size
      t.datetime :illustration_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :illustrations
  end
end

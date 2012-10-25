class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.string :name
      t.string :url
      t.integer :number, :default => 1
      t.string :description
      t.string :forum_picture_file_name
      t.string :forum_picture_content_type
      t.integer :forum_picture_file_size
      t.datetime :forum_picture_updated_at
      t.timestamps
    end
  end
end

class DropEmoticons < ActiveRecord::Migration
  def up
    drop_table :emoticons
  end

  def down
    create_table :emoticons do |t|
      t.string :name
      t.string :code
      t.string :emoticon_file_name
      t.string :emoticon_content_type
      t.integer :emoticon_file_size
      t.datetime :emoticon_updated_at
      t.timestamps
    end
  end
end

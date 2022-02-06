class CreateDownloads < ActiveRecord::Migration
  def self.up
    create_table :downloads do |t|
      t.string :name
      t.string :url
      t.string :description
      t.text :information
      t.string :download_file_name
      t.string :download_content_type
      t.integer :download_file_size
      t.datetime :download_updated_at
      t.boolean :publish
      t.references :category
      t.timestamps
    end
  end

  def self.down
    drop_table :downloads
  end
end

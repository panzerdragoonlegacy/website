class CreatePagesAgain < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.string :url
      t.string :description
      t.text :content
      t.boolean :publish
      t.string :page_type
      t.integer :parent_page_id
      t.integer :sequence_number
      t.references :category
      t.string :page_picture_file_name
      t.string :page_picture_content_type
      t.integer :page_picture_file_size
      t.datetime :page_picture_updated_at
      t.timestamps
      t.datetime :published_at
    end
  end
end

class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :name
      t.string :url
      t.string :description
      t.text :content
      t.boolean :publish
      t.references :category
      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
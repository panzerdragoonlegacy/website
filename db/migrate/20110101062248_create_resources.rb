class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.string :name
      t.string :url
      t.text :content
      t.boolean :publish
      t.references :category
      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end

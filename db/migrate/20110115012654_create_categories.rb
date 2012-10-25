class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.string :url
      t.string :description
      t.string :category_type
      t.boolean :publish
      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end

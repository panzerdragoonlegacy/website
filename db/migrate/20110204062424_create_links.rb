class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string :name
      t.string :url
      t.string :description
      t.references :category
      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end

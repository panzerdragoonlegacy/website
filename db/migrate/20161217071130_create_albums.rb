class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :name
      t.string :url
      t.string :description
      t.references :category, index: true

      t.timestamps null: false
    end

    add_foreign_key :albums, :categories
  end
end

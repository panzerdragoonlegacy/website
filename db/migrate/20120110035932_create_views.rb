class CreateViews < ActiveRecord::Migration
  def change
    create_table :views do |t|
      t.references :dragoon
      t.integer :viewable_id
      t.string :viewable_type
      t.boolean :viewed
      t.timestamps
    end
  end
end

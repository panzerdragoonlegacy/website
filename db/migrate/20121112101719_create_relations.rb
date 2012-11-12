class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.references :encyclopaedia_entry
      t.integer :relatable_id
      t.string :relatable_type
      t.timestamps
    end
  end
end

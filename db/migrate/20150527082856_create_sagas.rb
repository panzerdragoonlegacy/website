class CreateSagas < ActiveRecord::Migration
  def change
    create_table :sagas do |t|
      t.string :name
      t.string :url
      t.integer :sequence_number, default: 1
      t.references :encyclopaedia_entry, index: true

      t.timestamps null: false
    end
    add_foreign_key :sagas, :encyclopaedia_entries
  end
end

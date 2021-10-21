class CreateCategorisations < ActiveRecord::Migration[6.0]
  def change
    create_table :categorisations do |t|
      t.references :parent, foreign_key: { to_table: :categories }
      t.references :subcategory, foreign_key: { to_table: :categories }
      t.integer :sequence_number, default: 0
      t.string :short_name_in_parent
      t.timestamps
    end
  end
end

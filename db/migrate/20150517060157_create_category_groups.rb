class CreateCategoryGroups < ActiveRecord::Migration
  def change
    create_table :category_groups do |t|
      t.string :name
      t.string :url
      t.string :category_group_type

      t.timestamps null: false
    end
  end
end

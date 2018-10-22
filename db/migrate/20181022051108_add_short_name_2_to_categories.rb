class AddShortName2ToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :short_name_2, :string
  end
end

class AddTagToSagas < ActiveRecord::Migration[6.0]
  def change
    add_column :sagas, :tag_id, :integer
    remove_column :sagas, :page_id, :integer
  end
end

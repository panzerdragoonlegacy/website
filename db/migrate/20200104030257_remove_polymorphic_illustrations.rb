class RemovePolymorphicIllustrations < ActiveRecord::Migration
  def change
    remove_column :illustrations, :illustratable_type
    rename_column :illustrations, :illustratable_id, :page_id
  end
end

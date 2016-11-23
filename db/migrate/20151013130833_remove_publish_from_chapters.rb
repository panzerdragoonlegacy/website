class RemovePublishFromChapters < ActiveRecord::Migration
  def up
    remove_column :chapters, :publish
  end

  def down
    add_column :chapters, :publish, :boolean
    change_column_default :chapters, :publish, false
  end
end

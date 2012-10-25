class RenameDiscussionParent < ActiveRecord::Migration
  def change
    rename_column :discussions, :category_id, :forum_id
  end
end

class RemoveWindowsLiveIdFromDragoons < ActiveRecord::Migration
  def up
    remove_column :dragoons, :windows_live_id
  end

  def down
    add_column :dragoons, :windows_live_id, :string
  end
end

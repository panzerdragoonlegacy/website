class AddStickyToDiscussions < ActiveRecord::Migration
  def change
    add_column :discussions, :sticky, :boolean
  end
end

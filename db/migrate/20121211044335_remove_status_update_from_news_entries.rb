class RemoveStatusUpdateFromNewsEntries < ActiveRecord::Migration
  def up
    remove_column :news_entries, :status_update
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

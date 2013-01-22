class RemoveGuestbookEntries < ActiveRecord::Migration
  def up
    drop_table :guestbook_entries
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

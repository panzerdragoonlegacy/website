class ClearOldDatabaseTables < ActiveRecord::Migration
  def up
    remove_column :sagas, :encyclopaedia_entry_id
    EncyclopaediaEntry.delete_all
    Article.delete_all
    Poem.delete_all
    Resource.delete_all
    Chapter.delete_all
    Story.delete_all
  end
end

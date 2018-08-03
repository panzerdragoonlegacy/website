class RemoveEncyclopaediaEntryIdFromTaggings < ActiveRecord::Migration
  def change
    remove_column :taggings, :encyclopaedia_entry_id
  end
end

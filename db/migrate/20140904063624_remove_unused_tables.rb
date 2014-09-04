class RemoveUnusedTables < ActiveRecord::Migration
  def change
    drop_table :comments
    drop_table :discussions
    drop_table :forums
    drop_table :private_discussion_comments
    drop_table :private_discussion_members
    drop_table :private_discussions
    drop_table :project_discussion_comments
    drop_table :project_discussions
    drop_table :project_members
    drop_table :project_tasks
    drop_table :projects
    drop_table :views
  end
end

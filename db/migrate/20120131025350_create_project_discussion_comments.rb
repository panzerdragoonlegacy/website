class CreateProjectDiscussionComments < ActiveRecord::Migration
  def change
    create_table :project_discussion_comments do |t|
      t.text :message
      t.references :project_discussion
      t.references :dragoon
      t.timestamps
    end
  end
end

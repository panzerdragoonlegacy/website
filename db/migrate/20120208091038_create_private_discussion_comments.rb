class CreatePrivateDiscussionComments < ActiveRecord::Migration
  def change
    create_table :private_discussion_comments do |t|
      t.text :message
      t.references :private_discussion
      t.references :dragoon
      t.timestamps
    end
  end
end

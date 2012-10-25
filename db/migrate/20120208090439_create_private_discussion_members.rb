class CreatePrivateDiscussionMembers < ActiveRecord::Migration
  def change
    create_table :private_discussion_members do |t|
      t.references :private_discussion
      t.references :dragoon
      t.timestamps
    end
  end
end

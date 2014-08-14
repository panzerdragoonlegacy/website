class AddForumMemberIdToDragoons < ActiveRecord::Migration
  def change
    add_column :dragoons, :forum_member_id, :integer
  end
end

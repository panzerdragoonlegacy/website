class AddDiscourseUsername < ActiveRecord::Migration
  def up
    add_column :dragoons, :discourse_username, :string
    remove_column :dragoons, :forum_member_id
  end

  def down
    add_column :dragoons, :forum_member_id, :integer
    remove_column :dragoons, :discourse_username
  end
end

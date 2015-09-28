class AddContributorProfileToUsers < ActiveRecord::Migration
  def change
    add_column :users, :contributor_profile_id, :integer
  end
end

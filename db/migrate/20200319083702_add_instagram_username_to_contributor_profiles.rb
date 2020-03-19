class AddInstagramUsernameToContributorProfiles < ActiveRecord::Migration
  def change
    add_column :contributor_profiles, :instagram_username, :string
  end
end

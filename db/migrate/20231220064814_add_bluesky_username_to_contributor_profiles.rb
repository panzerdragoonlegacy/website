class AddBlueskyUsernameToContributorProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :contributor_profiles, :bluesky_username, :string
  end
end

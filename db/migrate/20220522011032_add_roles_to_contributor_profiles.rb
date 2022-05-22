class AddRolesToContributorProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :contributor_profiles, :roles, :string
    add_column :contributor_profiles, :information, :text
    add_column :contributor_profiles, :fediverse_username, :string
    add_column :contributor_profiles, :fediverse_url, :string
  end
end

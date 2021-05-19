class AddFieldsToContributorProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :contributor_profiles, :discord_user_id, :string
    add_column :contributor_profiles, :fandom_username, :string
  end
end

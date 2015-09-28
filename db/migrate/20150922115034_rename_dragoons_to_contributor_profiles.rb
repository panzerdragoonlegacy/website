class RenameDragoonsToContributorProfiles < ActiveRecord::Migration
  def change
    rename_table :dragoons, :contributor_profiles
    rename_column :news_entries, :dragoon_id, :contributor_profile_id
    rename_column :contributions, :dragoon_id, :contributor_profile_id
  end
end

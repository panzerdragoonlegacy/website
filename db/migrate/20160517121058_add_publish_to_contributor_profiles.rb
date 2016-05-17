class AddPublishToContributorProfiles < ActiveRecord::Migration
  def up
    add_column :contributor_profiles, :publish, :boolean

    # Ensure that existing contributor profiles remain published
    ContributorProfile.all.each do |contributor_profile|
      if contributor_profile.publish.blank?
        contributor_profile.publish = true
        contributor_profile.save
      end
    end

    # Ensure that future contributor profiles are not published by default
    change_column_default :contributor_profiles, :publish, false
  end

  def down
    remove_column :contributor_profiles, :publish
  end
end

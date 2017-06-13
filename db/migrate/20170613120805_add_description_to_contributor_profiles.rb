class AddDescriptionToContributorProfiles < ActiveRecord::Migration
  def change
    add_column :contributor_profiles, :description, :string
  end
end

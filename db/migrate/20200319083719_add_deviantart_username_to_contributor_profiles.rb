class AddDeviantartUsernameToContributorProfiles < ActiveRecord::Migration
  def change
    add_column :contributor_profiles, :deviantart_username, :string
  end
end

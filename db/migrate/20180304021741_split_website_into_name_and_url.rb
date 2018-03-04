class SplitWebsiteIntoNameAndUrl < ActiveRecord::Migration
  def change
    add_column :contributor_profiles, :website_name, :string
    rename_column :contributor_profiles, :website, :website_url
  end
end

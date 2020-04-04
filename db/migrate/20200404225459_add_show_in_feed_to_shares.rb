class AddShowInFeedToShares < ActiveRecord::Migration
  def change
    add_column :shares, :show_in_feed, :boolean, default: true
  end
end

class AddPublishFieldsToShares < ActiveRecord::Migration
  def up
    add_column :shares, :publish, :boolean, default: false
    add_column :shares, :published_at, :datetime

    Share.all.each do |share|
      share.publish = true
      share.published_at = share.created_at
      share.save
    end
  end
end

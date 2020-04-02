class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.string :url
      t.string :comment
      t.references :category
      t.references :contributor_profile
      t.timestamps
    end
  end
end

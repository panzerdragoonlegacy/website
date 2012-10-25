class CreateContributions < ActiveRecord::Migration
  def self.up
    create_table :contributions do |t|
      t.references :dragoon
      t.integer :contributable_id
      t.string :contributable_type
      t.timestamps
    end
  end

  def self.down
    drop_table :contributions
  end
end

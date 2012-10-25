class CreatePrivateDiscussions < ActiveRecord::Migration
  def change
    create_table :private_discussions do |t|
      t.string :subject
      t.text :message
      t.references :dragoon
      t.timestamps
    end
  end
end

class CreateProjectDiscussions < ActiveRecord::Migration
  def change
    create_table :project_discussions do |t|
      t.string :subject
      t.text :message
      t.boolean :sticky
      t.references :dragoon
      t.references :project
      t.timestamps
    end
  end
end

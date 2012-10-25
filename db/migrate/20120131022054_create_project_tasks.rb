class CreateProjectTasks < ActiveRecord::Migration
  def change
    create_table :project_tasks do |t|
      t.string :name
      t.boolean :completed
      t.references :project
      t.references :dragoon
      t.timestamps
    end
  end
end

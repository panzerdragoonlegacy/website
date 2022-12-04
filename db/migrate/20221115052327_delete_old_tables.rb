class DeleteOldTables < ActiveRecord::Migration[7.0]
  def up
    drop_table :quiz_answers
    drop_table :quiz_questions
    drop_table :quizzes
    drop_table :category_groups
    drop_table :sagas
    drop_table :resources
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

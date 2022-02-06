class CreateQuizAnswers < ActiveRecord::Migration
  def self.up
    create_table :quiz_answers do |t|
      t.integer :quiz_question_id
      t.text :content
      t.boolean :correct_answer, default: :false
      t.timestamps
    end
  end

  def self.down
    drop_table :quiz_answers
  end
end

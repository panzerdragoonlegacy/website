class AddCategoryIdToQuizzes < ActiveRecord::Migration[6.0]
  def change
    add_column :quizzes, :category_id, :integer
  end
end

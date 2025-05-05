class AddIndexToQuestions < ActiveRecord::Migration[7.1]
  def change
    add_index :questions, [:created_at], name: 'index_questions_on_create_desc', order: { created_at: :desc }
  end
end

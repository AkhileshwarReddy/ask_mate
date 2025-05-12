class AddAnswersCountToQuestions < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :answers_count, :integer, null: false, default: 0
  end
end

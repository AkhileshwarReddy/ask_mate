class CreateAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :answers do |t|
      t.text :body,           null: false
      t.string :status,       null: false, default: 'open'
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end

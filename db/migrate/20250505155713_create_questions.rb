class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.string :title,  null: false
      t.text :body,     null: false
      t.string :status, null: false, default: "open"
      t.integer :view_count, null: false, default: 0

      t.timestamps
    end
  end
end

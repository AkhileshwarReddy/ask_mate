class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.text :body,                 null: false
      t.string :commentable_type,   null: false
      t.bigint :commentable_id,     null: false

      t.timestamps
    end
  end
end

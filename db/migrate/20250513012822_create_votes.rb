class CreateVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :votes do |t|
      t.integer :value,         null: false
      t.bigint  :created_by,    null: false
      t.references :votable, polymorphic: true, null: false

      t.timestamps
    end

    add_foreign_key :votes, :users, column: :created_by

    add_index :votes, %i[votable_type votable_id]
    add_index :votes, %i[created_by votable_type votable_id]
  end
end

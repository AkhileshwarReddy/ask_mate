class ReplaceAnswerStatusWithAcceptedFlag < ActiveRecord::Migration[7.1]
  def change
    remove_column :answers, :status
    
    add_column  :answers, :accepted, :boolean, default: false, null: false
  end
end

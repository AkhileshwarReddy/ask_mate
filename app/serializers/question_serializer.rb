class QuestionSerializer < BaseSerializer
  attributes :title, :body, :status, :view_count, :created_at, :updated_at
end

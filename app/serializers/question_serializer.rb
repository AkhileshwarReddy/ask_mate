class QuestionSerializer < BaseSerializer
  attributes :title, :body, :status, :view_count, :answers_count#, :created_at, :updated_at
  
  attribute :tags do |question|
    question.tags.map { |tag| tag.name }
  end
end

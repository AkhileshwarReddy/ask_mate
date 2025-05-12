class AnswerSerializer < BaseSerializer
  attributes :body, :accepted

  attribute :question_id do |answer|
    answer.question_id
  end
end

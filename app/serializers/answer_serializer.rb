class AnswerSerializer < BaseSerializer
  attrbutes :body, :accepted

  attribute :question_id do |answer|
    answer.question_id
  end
end

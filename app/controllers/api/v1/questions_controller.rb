module Api
    module V1
        class QuestionsController < BaseController
            def index
                questions = Question.all
                serializer = QuestionSerializer.new(questions)

                render_success(
                    serializer: serializer,
                    message: "Questions fetched succesfully"
                )
            end
        end
    end
end

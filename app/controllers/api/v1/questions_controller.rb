module Api
    module V1
        class QuestionsController < BaseController
            def index
                scope = Question.order(created_at: :desc)
                page_data = paginate(scope)
                serializer = QuestionSerializer.new(page_data)

                render_success(
                    serializer: serializer,
                    message: "Questions fetched succesfully",
                    meta: pagination_meta(page_data)
                )
            end
        end
    end
end

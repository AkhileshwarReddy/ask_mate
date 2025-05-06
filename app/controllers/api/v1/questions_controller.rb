module Api
    module V1
        class QuestionsController < BaseController
            def index
                result = ::Questions::FetchIndex.new(params).call

                render_success(
                    serializer: nil,
                    message: "Questions fetched succesfully",
                    meta: result[:meta]
                ) { result[:data] }
            end
        end
    end
end

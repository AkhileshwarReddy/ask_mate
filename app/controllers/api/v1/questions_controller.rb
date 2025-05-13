module Api
    module V1
        class QuestionsController < BaseController
            before_action :set_filters, only: :index
            before_action :set_question, only: %i[update destroy]

            after_action :expire_question_from_cache, only: %i[update destroy]
            after_action :expire_index_cache, only: %i[create update destroy]

            def index
                result = ::Questions::FetchIndex.new(params).call

                render_success(
                    message: "Questions fetched successfully",
                    meta: result[:meta]
                ) { result[:data] }
            end

            def show
                result = ::Questions::FetchShow.new(params).call
                
                render_success(message: "Question fetched successfully") do
                    result[:data]
                end
            end

            def create
                question = ::Questions::Create.new(
                    question_attrs: question_params.except(:tags),
                    tag_names: question_params[:tags] || []
                ).call

                render_success(message: "Question created successfully", status: :created) do
                    QuestionSerializer.new(question).serializable_hash[:data]
                end
            end

            def update
                @question.update!(question_params)

                render_success(message: "Question updated successfully") do
                    QuestionSerializer.new(@question).serializable_hash[:data]
                end
            end

            def destroy
                @question.destroy!

                head :no_content
            end

            private

            def set_filters
                @filter_tags = params.permit(tags: []).fetch(:tags, []).reject(&:blank)
            end

            def question_params
                params.require(:question).permit(:title, :body, :status, :rancho, tags: [])
            end

            def set_question
                @question = Question.find(params[:id])
            end

            def expire_index_cache
                expire_matched_cache("questions/page=*")
            end

            def expire_question_from_cache
                expire_cache("question/#{params[:id]}")
            end
        end
    end
end

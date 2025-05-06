module Api
    module V1
        class AnswersController < BaseController
            before_action :set_question
            before_action :set_answer, only: %i[show update destroy]

            def index
                answers = @question.answers.recent

                render_success(message: "Answers fetched successfully") do
                    AnswerSerializer.new(answers).serializable_hash[:data]
                end
            end

            def show
                render_success(message: "Answer fetched successfully") do
                    AnswerSerializer.new(@answer).serializable_hash[:data]
                end
            end

            def create
                answer = @question.answers.create!(answer_params)

                render_success(message: "Answer created successfully", status: :created) do
                    AnswerSerializer.new(answer).serializable_hash[:data]
                end
            end

            def update
                @answer.update!(answer_params)
                
                render_success(message: "Answer updated successfully") do
                    AnswerSerializer.new(@answer).serializable_hash[:data]
                end
            end

            def destroy
                @answer.destroy!
                head :no_content
            end

            private

            def set_question
                @question = Question.find(params[:question_id])
            end

            def set_answer
                @answer = @question.answers.find(params[:id])
            end

            def answer_params
                params.require(:answer).permit(:body, :accepted)
            end
        end
    end
end

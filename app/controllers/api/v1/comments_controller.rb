module Api
    module V1
        class CommentsController < BaseController
            before_action :set_commentable

            def index
                comments = @commentable.comments.recent

                render_success(message: "Comments fetched successfully") do
                    CommentSerializer.new(comments).serializable_hash[:data]
                end
            end

            def show
                comment = @commentable.comments.find(params[:id])

                render_success(message: "Comment fetched successfuly") do
                    CommentSerializer.new(comment).serializable_hash[:data]
                end
            end

            def create
                comment = @commentable.comments.create!(comment_params)

                render_success(message: "Comment created successfuly") do
                    CommentSerializer.new(comment).serializable_hash[:data]
                end
            end

            def update
                comment = @commentable.comments.where(id: params[:id]).update!(comment_params)

                render_success(message: "Comment updated successfuly") do
                    CommentSerializer.new(comment).serializable_hash[:data]
                end
            end

            def destroy
                @commentable.comments.find(params[:id]).destroy!

                head :no_content
            end

            private

            def comment_params
                params.require(:comment).permit(:body)
            end

            def set_commentable
                if params[:answer_id]
                    @commentable = Answer.find(params[:answer_id])
                elsif params[:question_id]
                    @commentable = Question.find(params[:question_id])
                else
                    # It should never happen if the routes are correct
                    raise ActionController::BadRequest, "Missing commentable"
                end
            end
        end
    end
end

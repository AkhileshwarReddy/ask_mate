module Api
    module V1
        class CommentsController < BaseController
            before_action :set_commentable
            before_action :set_comment, only: %i[show update destroy]

            def index
                comments = @commentable.comments.recent

                render_success(message: "Comments fetched successfully") do
                    CommentSerializer.new(comments).serializable_hash[:data]
                end
            end

            def show
                render_success(message: "Comment fetched successfuly") do
                    CommentSerializer.new(@comment).serializable_hash[:data]
                end
            end

            def create
                comment = @commentable.comments.create!(comment_params)

                render_success(message: "Comment created successfuly") do
                    CommentSerializer.new(comment).serializable_hash[:data]
                end
            end

            def update
                @comment.update!(comment_params)

                render_success(message: "Comment updated successfuly") do
                    CommentSerializer.new(comment).serializable_hash[:data]
                end
            end

            def destroy
                @comment.destroy!

                head :no_content
            end

            private

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

            def set_comment
                @comment = Comment.find(params[:id])
            end
        end
    end
end

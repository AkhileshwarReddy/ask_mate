module Api
    module V1
        class VotesController < BaseController
            def upvote
                apply_vote(+1)
            end

            def downvote
                apply_vote(+1)
            end

            private

            def apply_vote(value)
                vote = @votable.votes.find_or_initialize_by()
            end

            def set_votable
                if params[:question_id] && (params[:answer_id] || request.path.include?("/comments/"))
                    @votable = Comment.find(params[:id])
                elsif params[:question_id] && params[:id]
                    @votable = Answer.find(params[:id])
                elsif params[:id]
                    @votable = Question.find(params[:id])
                end
            end 
        end
    end
end

module Questions
    class FetchIndex
        attr_reader :filter_tags

        def initialize(filter_tags:)
            @filter_tags = filter_tags
        end

        def call
            fetch_questions
        end

        private

        def fetch_questions
            if filter_attrs.present?
                Question.with_tags(@filter_tags).recent
            else
                Question.recent
            end
        end
    end
end

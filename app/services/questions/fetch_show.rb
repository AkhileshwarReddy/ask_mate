module Questions
    class FetchShow
        include Cacheable

        attr_reader :params, :model, :serializer

        def initialize(params, model=Question, serializer: QuestionSerializer)
            @params = params
            @model = model
            @serializer = serializer
        end

        def call
            fetch_cache(cache_key) { build_payload(question) }
        end

        private
        
        def cache_key
            "question/#{params[:id]}"
        end

        def question
            Question.find(params[:id])
        end

        def build_payload(data)
            ser_hash = serializer.new(question).serializable_hash

            {
                data: ser_hash[:data]
            }
        end
    end
end
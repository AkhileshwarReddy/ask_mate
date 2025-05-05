module Questions
    class FetchIndex
        include Cacheable
        include Paginatable

        attr_reader :params

        def initialize(params, model: Question, serializer: QuestionSerializer)
            @params = params
            @model = model
            @serializer = serializer
        end

        def call
            fetch_cache(cache_key) { build_payload(page_data) }
        end

        private

        def page_data
            @page_data ||= paginate(@model.order(created_at: :desc))
        end

        def cache_key
            p = pagination_params

            "questions/page=#{p[:page]}/per=#{p[:per_page]}/v=#{latest_timestamp(page_data)}"
        end

        def latest_timestamp(data)
            data.maximum(:updated_at)&.to_i || 0
        end

        def build_payload(data)
            ser_hash = @serializer.new(
                data,
                meta: pagination_meta(data)
            ).serializable_hash

            {
                data: ser_hash[:data],
                meta: ser_hash[:meta]
            }
        end
    end
end

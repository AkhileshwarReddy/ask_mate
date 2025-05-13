module Questions
    class FetchIndex
        include Cacheable
        include Paginatable

        attr_reader :params, :filter_tags

        def initialize(params)
            @params = params
            @filter_tags = params.fetch(:tags)&.split(',') || []
        end

        def call
            fetch_cache(cache_key) { build_payload(page_data) }
        end

        private

        def page_data
            @page_data ||= paginate(fetch_questions)
        end

        def cache_key
            p = pagination_params
            
            "questions/page=#{p[:page]}/per=#{p[:per_page]}/v=#{latest_timestamp(page_data)}"
        end

        def latest_timestamp(data)
            data.maximum(:updated_at)&.to_i || 0
        end

        def fetch_questions
            scope = if filter_tags.present?
                Question.with_tags(filter_tags).recent
            else
                Question.recent
            end

            scope
        end

        def build_payload(data)
            ser_hash = QuestionSerializer.new(data, meta: pagination_meta(data))
                .serializable_hash

            {
                data: ser_hash[:data],
                meta: ser_hash[:meta]
            }
        end
    end
end

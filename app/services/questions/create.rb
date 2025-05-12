module Questions
    class Create
        include Cacheable

        attr_reader :question_attrs, :tag_names, :question

        def initialize(question_attrs: , tag_names: [])
            @question_attrs = question_attrs
            @tag_names = tag_names
        end

        def call
            ActiveRecord::Base.transaction do
                create_question
                assign_tags
                
                question
            end
        end

        private

        def create_question
            @question = Question.create!(question_attrs)
        end

        def assign_tags
            existing = Tag.where(name: tag_names).index_by(&:name)
            to_create = tag_names - existing.keys
            new_tags = to_create.map { |name| Tag.create!(name: name) }
            @question.tags = existing.values + new_tags
        end
    end
end
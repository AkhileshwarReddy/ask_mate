class Comment < ApplicationRecord
    belongs_to :commentable, polymorphic: true

    validates :body, presence: true

    scope :recent, -> { where(created_at: :desc) }
end

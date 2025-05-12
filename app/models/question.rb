class Question < ApplicationRecord
    has_many :answers, dependent: :destroy
    has_many :comments, as: :commentable, dependent: :destroy
    
    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings
    
    STATUSES = %w[open closed].freeze

    validates :title, presence: true, length: { minimum: 10, maximum: 150 }
    validates :body, presence: true, length: { minimum: 50, maximum: 1000 }
    validates :status, presence: true, inclusion: { in: STATUSES }

    scope :with_tags, -> (names) { where(tags: { name: names }).distinct }
end

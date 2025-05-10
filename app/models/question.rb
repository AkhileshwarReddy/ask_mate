class Question < ApplicationRecord
    has_many :answers, dependent: :destroy
    
    STATUSES = %w[open closed].freeze

    validates :title, presence: true, length: { minimum: 10, maximum: 150 }
    validates :body, presence: true, length: { minimum: 50, maximum: 1000 }
    validates :status, presence: true, inclusion: { in: STATUSES }
end

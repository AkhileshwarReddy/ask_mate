class Answer < ApplicationRecord
  belongs_to :question

  validates :body, presence: true, length: { minimum: 50, maximum: 1000 }
  validates :accepted, presence: true, inclusion: { in: [true, false] }

  scope :recent, -> { order(created_at: :desc) }
  scope :accepted, -> { where(accepted: true) }
  scope :unaccepted, -> { where(accepted: false) }

  def accept!
    update!(accepted: true)
  end

  def unaccept!
    update!(accepted: false)
  end
end

class Answer < ApplicationRecord
  before_validation :ensure_acceptance, on: :create

  belongs_to :question
  
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true, length: { minimum: 50, maximum: 1000 }
  validates :accepted, inclusion: { in: [true, false] }

  scope :recent, -> { order(created_at: :desc) }
  scope :accepted_only, -> { where(accepted: true) }
  scope :unaccepted_only, -> { where(accepted: false) }

  def accept!
    update!(accepted: true)
  end

  def unaccept!
    update!(accepted: false)
  end

  private

  def ensure_acceptance
    self.accepted ||= false
  end
end

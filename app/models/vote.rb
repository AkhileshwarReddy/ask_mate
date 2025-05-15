class Vote < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: :created_by
  belongs_to :votable, polymorphic: true

  validates :value, presence: true, inclusion: { in: [-1, +1] }
  validates :created_by, uniqueness: { scope: %i[votable_type votable_id] }, message: "can only vote once per item"
end

class TaskLog < ApplicationRecord
  belongs_to :task

  validates :status, presence: true

  scope :successful, -> { where(status: "success") }
  scope :failed,     -> { where(status: "failed") }
  scope :recent,     -> { order(created_at: :desc) }
  scope :last_month, -> { where("created_at >= ?", 30.days.ago) }
end

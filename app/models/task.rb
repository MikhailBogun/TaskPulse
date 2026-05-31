class Task < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :task_logs, dependent: :destroy

  enum :status, { pending: 0, running: 1, success: 2, failed: 3 }, default: :pending

  validates :name, presence: true, length: { maximum: 255 }

  scope :due_now, -> { pending.where("scheduled_at <= ?", Time.current) }
  scope :recent, -> { order(created_at: :desc) }
end

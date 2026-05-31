class AlertRule < ApplicationRecord
  belongs_to :user

  RULE_TYPES = %w[crypto github].freeze
  CONDITIONS = %w[below above].freeze
  CHANNELS = %w[telegram slack].freeze

  validates :name, presence: true
  validates :rule_type, inclusion: { in: RULE_TYPES }
  validates :condition, inclusion: { in: CONDITIONS }
  validates :notification_channel, inclusion: { in: CHANNELS }
  validates :threshold, numericality: { greater_than: 0 }

  scope :active,      -> { where(active: true) }
  scope :crypto_type, -> { where(rule_type: "crypto") }
  scope :github_type, -> { where(rule_type: "github") }
end

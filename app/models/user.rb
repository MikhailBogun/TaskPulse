class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :recoverable,
    :validatable, :confirmable,
    :jwt_authenticatable, jwt_revocation_strategy: self

  enum :plan, { free: 0, trial: 1, pro: 2, enterprise: 3 }, default: :trial

  has_many :tasks, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :alert_rules, dependent: :destroy

  pay_customer

  PLAN_LIMITS = {
    free: { tasks: 10, categories: 3 },
    trial: { tasks: 100, categories: 20 },
    pro: { tasks: 100, categories: 20 },
    enterprise: { tasks: Float::INFINITY, categories: Float::INFINITY }
  }.freeze

  def plan_limit(resource)
    PLAN_LIMITS.dig(plan.to_sym, resource) || 0
  end

  def trial_expired?
    trial? && trial_ends_at.present? && trial_ends_at < Time.current
  end

  def active_subscription?
    pro? || enterprise? || (trial? && !trial_expired?)
  end

  def grace_period?
    grace_period_ends_at.present? && grace_period_ends_at > Time.current
  end
end

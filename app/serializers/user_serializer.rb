class UserSerializer < Blueprinter::Base
  identifier :id

  fields :email, :plan, :confirmed_at, :created_at

  field :trial_ends_at do |user|
    user.trial_ends_at&.iso8601
  end

  field :grace_period_ends_at do |user|
    user.grace_period_ends_at&.iso8601
  end

  field :active_subscription do |user|
    user.active_subscription?
  end

  field :plan_limits do |user|
    User::PLAN_LIMITS[user.plan.to_sym]
  end
end

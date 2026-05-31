module Subscriptions
  class HandleSubscriptionUpdated < ApplicationService
    PLAN_MAP = {
      ENV.fetch("STRIPE_PRO_PRICE_ID", "price_pro") => "pro",
      ENV.fetch("STRIPE_ENTERPRISE_PRICE_ID", "price_enterprise") => "enterprise"
    }.freeze

    def initialize(pay_subscription:)
      @pay_subscription = pay_subscription
      @user = pay_subscription.customer.owner
    end

    def call
      new_plan = PLAN_MAP[@pay_subscription.processor_plan]
      return unless new_plan

      @user.update!(plan: new_plan, grace_period_ends_at: nil)
    end
  end
end

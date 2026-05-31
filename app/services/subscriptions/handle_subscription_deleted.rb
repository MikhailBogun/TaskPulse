module Subscriptions
  class HandleSubscriptionDeleted < ApplicationService
    def initialize(pay_subscription:)
      @pay_subscription = pay_subscription
      @user = pay_subscription.customer.owner
    end

    def call
      @user.update!(plan: :free, grace_period_ends_at: nil, stripe_subscription_id: nil)
      SubscriptionMailer.subscription_cancelled(@user).deliver_later
    end
  end
end

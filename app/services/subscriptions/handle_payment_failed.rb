module Subscriptions
  class HandlePaymentFailed < ApplicationService
    GRACE_PERIOD_DAYS = 3

    def initialize(pay_charge:)
      @pay_charge = pay_charge
      @user = pay_charge.customer.owner
    end

    def call
      @user.update!(grace_period_ends_at: GRACE_PERIOD_DAYS.days.from_now)
      SubscriptionMailer.payment_failed(@user).deliver_later
    end
  end
end

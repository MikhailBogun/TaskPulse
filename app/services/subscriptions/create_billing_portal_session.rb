module Subscriptions
  class CreateBillingPortalSession < ApplicationService
    def initialize(user:)
      @user = user
    end

    def call
      session = @user.payment_processor.billing_portal(
        return_url: "#{ENV.fetch("FRONTEND_URL")}/billing"
      )

      { portal_url: session.url }
    end
  end
end

module Subscriptions
  class CreateCheckoutSession < ApplicationService
    PRICE_IDS = {
      "pro" => ENV.fetch("STRIPE_PRO_PRICE_ID", "price_pro"),
      "enterprise" => ENV.fetch("STRIPE_ENTERPRISE_PRICE_ID", "price_enterprise")
    }.freeze

    def initialize(user:, plan:)
      @user = user
      @plan = plan
    end

    def call
      price_id = PRICE_IDS[@plan]
      raise ArgumentError, "Invalid plan: #{@plan}" unless price_id

      session = @user.payment_processor.checkout(
        mode: "subscription",
        line_items: [ { price: price_id, quantity: 1 } ],
        success_url: "#{ENV.fetch("FRONTEND_URL")}/billing?success=true",
        cancel_url: "#{ENV.fetch("FRONTEND_URL")}/billing?canceled=true",
        allow_promotion_codes: true
      )

      { checkout_url: session.url }
    end
  end
end

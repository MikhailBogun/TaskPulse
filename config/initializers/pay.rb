Pay.setup do |config|
  config.business_name = "TaskPulse"
  config.business_address = ""
  config.application_name = "TaskPulse"
  config.support_email = ENV.fetch("SUPPORT_EMAIL") { "support@taskpulse.io" }

  config.default_product_name = "TaskPulse Subscription"
  config.default_plan_name = "Pro"

  config.automount_routes = true
  config.routes_path = "/pay"

  config.emails.payment_failed = true
  config.emails.subscription_renewing = true
  config.emails.receipt = true
  config.emails.refund = true
end

Pay::Webhooks.delegator.subscribe("stripe.customer.subscription.updated", PayWebhookSubscriber.new)
Pay::Webhooks.delegator.subscribe("stripe.customer.subscription.deleted", PayWebhookSubscriber.new)
Pay::Webhooks.delegator.subscribe("stripe.invoice.payment_failed", PayWebhookSubscriber.new)

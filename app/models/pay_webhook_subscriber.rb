class PayWebhookSubscriber
  def subscription_updated(event)
    pay_subscription = Pay::Subscription.find_by(processor_id: event.data.object.id)
    return unless pay_subscription

    Subscriptions::HandleSubscriptionUpdated.call(pay_subscription: pay_subscription)
  end

  def subscription_deleted(event)
    pay_subscription = Pay::Subscription.find_by(processor_id: event.data.object.id)
    return unless pay_subscription

    Subscriptions::HandleSubscriptionDeleted.call(pay_subscription: pay_subscription)
  end

  def payment_failed(event)
    pay_charge = Pay::Charge.find_by(processor_id: event.data.object.charge)
    return unless pay_charge

    Subscriptions::HandlePaymentFailed.call(pay_charge: pay_charge)
  end
end

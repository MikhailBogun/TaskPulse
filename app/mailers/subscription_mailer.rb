class SubscriptionMailer < ApplicationMailer
  def payment_failed(user)
    @user = user
    @grace_period_end = user.grace_period_ends_at&.strftime("%B %d, %Y")
    mail(to: user.email, subject: "Action required: Payment failed for your TaskPulse subscription")
  end

  def subscription_cancelled(user)
    @user = user
    mail(to: user.email, subject: "Your TaskPulse subscription has been cancelled")
  end

  def trial_ending(user)
    @user = user
    @days_remaining = ((user.trial_ends_at - Time.current) / 1.day).ceil
    mail(to: user.email, subject: "Your TaskPulse trial ends in #{@days_remaining} days")
  end
end

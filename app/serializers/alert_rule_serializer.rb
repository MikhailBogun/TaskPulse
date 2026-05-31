class AlertRuleSerializer < Blueprinter::Base
  identifier :id

  fields :name, :rule_type, :condition, :threshold, :notification_channel, :active,
    :last_triggered_at, :created_at
end

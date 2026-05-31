class CryptoAlertJob < ApplicationJob
  queue_as :low

  def perform
    AlertRule.active.crypto_type.find_each do |rule|
      Crypto::CheckPriceAlert.call(alert_rule: rule)
    rescue StandardError => e
      Rails.logger.error("CryptoAlertJob failed for rule #{rule.id}: #{e.message}")
    end
  end
end

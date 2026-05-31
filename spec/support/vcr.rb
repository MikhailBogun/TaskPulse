require 'vcr'
require 'webmock/rspec'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.filter_sensitive_data('<GITHUB_TOKEN>') { ENV['GITHUB_ACCESS_TOKEN'] }
  config.filter_sensitive_data('<STRIPE_KEY>') { ENV['STRIPE_SECRET_KEY'] }
  config.filter_sensitive_data('<TELEGRAM_TOKEN>') { ENV['TELEGRAM_BOT_TOKEN'] }
  config.default_cassette_options = { record: :new_episodes }
end

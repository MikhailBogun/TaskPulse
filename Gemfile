source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.0"

gem "rails", "~> 7.2.2"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[windows jruby]

# Auth
gem "devise"
gem "devise-jwt", "~> 0.11"

# CORS
gem "rack-cors"

# Serialization
gem "blueprinter", "~> 1.3"

# Background jobs
gem "sidekiq", "~> 7.0"
gem "sidekiq-cron", "~> 1.12"

# Payments
gem "pay", "~> 6.0"
gem "stripe", "~> 10.0"

# HTTP client for external APIs
gem "faraday", "~> 2.9"
gem "faraday-retry", "~> 2.2"

# Email
gem "sendgrid-ruby"

# PDF generation
gem "prawn", "~> 2.5"

# Active Storage with S3
gem "aws-sdk-s3", require: false

# Pin to avoid Ruby 3.3 SyntaxError with connection_pool 3.x
gem "connection_pool", "~> 2.4"

# Pagination
gem "kaminari"

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rubocop-rspec", require: false
  gem "rspec-rails", "~> 6.1"
  gem "factory_bot_rails"
  gem "faker"
  gem "shoulda-matchers", "~> 5.3"
  gem "pry-byebug"
  gem "dotenv-rails"
end

group :test do
  gem "vcr", "~> 6.2"
  gem "webmock", "~> 3.23"
  gem "simplecov", require: false
  gem "stripe-ruby-mock", require: "stripe_mock"
end

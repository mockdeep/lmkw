# frozen_string_literal: true

# 1. store check values
#   on each request rather than rendering check results directly, store check values, then render *stored* values
#   add actual logic to RunAllOutdated
#   store additional metadata on the `counts` table?
#     maybe on the `Check` instance
# 2. regular task (1 hour)
#   integrate Delayed::Job
#   every hour run RunAllOutdated
# 3. don't check on every page refresh
#   instead rely on stored values
# 4. handle initial check setup in background job rather than pinging API directly in request
#
# queue library alternatives
# X que - [reject] requires :sql schema format for db functions
# X sidekiq - [reject] unreliable, when Ruby process quits jobs can get lost
# X delayed_job - [reject] unmaintained
#                 consider adopting https://github.com/collectiveidea/delayed_job/issues/1105
# ? resque - moderately maintained, seems to have robust logic when process quits
# X sneakers/bunny - [reject] too much to learn
source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read("./.ruby-version").strip

# needs to be included before any other gems that use environment variables
gem "dotenv-rails", groups: [:development, :test]

gem "rails", "~> 6.0.2"

gem "bcrypt"
gem "bootsnap", require: false
gem "haml-rails"
gem "octokit"
gem "pg"
gem "pry-rails"
gem "puma"
gem "ruby-trello", require: "trello"
gem "sass-rails"
gem "delayed_job_active_record"
gem "strong_migrations"
gem "turbolinks"
gem "webpacker"
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

group :development, :test do
  gem "bundler-audit"
  gem "byebug"
  gem "faker"
  gem "pry-byebug"
  gem "rspec-rails"
end

group :development do
  gem "brakeman", require: false
  gem "guard", require: false
  gem "guard-haml_lint", require: false
  gem "guard-rspec", require: false
  gem "guard-rubocop", require: false
  gem "haml_lint", require: false
  gem "listen"
  gem "rubocop"
  gem "rubocop-rails"
  gem "rubocop-rspec"
  gem "spring"
  gem "spring-commands-rspec"
  gem "spring-watcher-listen"
  gem "web-console"
end

group :test do
  gem "capybara", require: false
  gem "capybara-screenshot", require: false
  gem "capybara_discoball", require: false
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "sinatra", require: false
  gem "webdrivers"
  gem "webmock", require: false
end

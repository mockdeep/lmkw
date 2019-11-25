# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?
  Dotenv.require_keys("GITHUB_EMAIL", "GITHUB_PASSWORD")
end

# frozen_string_literal: true

def fake_apis?
  # default to faking APIs unless explicitly disabled
  ENV["FAKE_APIS"] != "false"
end

require_relative "webmock" if fake_apis?

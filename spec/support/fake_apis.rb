# frozen_string_literal: true

module FakeApis
  def self.enabled?
    # default to faking APIs unless explicitly disabled
    ENV["FAKE_APIS"] != "false"
  end
end

require_relative "webmock" if FakeApis.enabled?

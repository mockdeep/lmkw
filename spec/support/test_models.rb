# frozen_string_literal: true

module Test
  class Integration < Integration
  end

  class Check < Check
    def self.next_values
      @next_values ||= []
    end

    def next_count
      next_value = self.class.next_values.shift

      raise StandardError, "no next value provided" unless next_value

      next_value
    end

    def service
      "test"
    end

    def icon
      ["fas", "test"]
    end

    def url
      "/test"
    end

    def message
      "test values"
    end
  end
end

RSpec.configure do |config|
  config.after do
    Test::Check.next_values.clear
  end
end

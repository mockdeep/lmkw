# frozen_string_literal: true

module Test
  class Integration < Integration
  end

  class Check < Check
    def refresh
      counts.create!(value: 53)
    end
  end
end

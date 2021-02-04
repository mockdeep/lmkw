# frozen_string_literal: true

module Matchers
  class HaveNoInactiveChecks < HaveNoChecks
    def matches?(page)
      super(page.find(".inactive"))
    end
  end
end

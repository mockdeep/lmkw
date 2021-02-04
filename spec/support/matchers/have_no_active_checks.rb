# frozen_string_literal: true

require_relative "./have_no_checks"

module Matchers
  class HaveNoActiveChecks < HaveNoChecks
    def matches?(page)
      super(page.find(".active"))
    end
  end
end

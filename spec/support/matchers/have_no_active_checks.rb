# frozen_string_literal: true

require_relative "have_no_checks"

class Matchers::HaveNoActiveChecks < Matchers::HaveNoChecks
  def matches?(page)
    super(page.find(".active"))
  end
end

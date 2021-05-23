# frozen_string_literal: true

class Matchers::HaveNoInactiveChecks < Matchers::HaveNoChecks
  def matches?(page)
    super(page.find(".inactive"))
  end
end

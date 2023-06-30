# frozen_string_literal: true

require_relative "have_check"

class Matchers::HaveInactiveCheck < Matchers::HaveCheck
  def matches?(page)
    super(page.find(".inactive"))
  end
end

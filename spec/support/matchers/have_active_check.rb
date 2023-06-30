# frozen_string_literal: true

require_relative "have_check"

class Matchers::HaveActiveCheck < Matchers::HaveCheck
  def matches?(page)
    super(page.find(".active"))
  end
end

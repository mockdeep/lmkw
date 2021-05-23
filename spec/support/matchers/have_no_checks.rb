# frozen_string_literal: true

class Matchers::HaveNoChecks
  attr_accessor :page

  def matches?(page)
    self.page = page
    page.has_no_selector?(".card")
  end

  def failure_message
    check_names = page.all(".card > h3").map(&:text)
    "expected page to have no checks, but had: #{check_names}"
  end
end

# frozen_string_literal: true

require_relative "./have_check"

module Matchers
  class HaveActiveCheck < HaveCheck
    def matches?(page)
      super(page.find(".active"))
    end
  end
end

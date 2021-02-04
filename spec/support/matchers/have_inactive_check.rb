# frozen_string_literal: true

require_relative "./have_check"

module Matchers
  class HaveInactiveCheck < HaveCheck
    def matches?(page)
      super(page.find(".inactive"))
    end
  end
end

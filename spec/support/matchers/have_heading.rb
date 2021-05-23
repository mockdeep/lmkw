# frozen_string_literal: true

class Matchers::HaveHeading
  attr_reader :text

  def initialize(text)
    @text = text
  end

  def matches?(page)
    page.has_selector?("h2", text: text)
  end

  def failure_message
    <<~MESSAGE.squish
      expected to find h2 tag with text #{text} but was not found
    MESSAGE
  end
end

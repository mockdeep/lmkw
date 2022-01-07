# frozen_string_literal: true

class Matchers::HaveFlash
  attr_reader :expected_type, :expected_message, :actual

  include RSpec::Matchers::Composable

  def initialize(expected_type, expected_message)
    @expected_type = expected_type
    @expected_message = expected_message
  end

  def matches?(actual)
    @actual = actual

    actual.has_selector?(expected_selector, text: expected_message)
  end

  def failure_message
    actual.has_selector?("[class^='flash-']") ? some_message : none_message
  end

  private

  def some_message
    <<~MESSAGE.squish
      expected to find #{expected_type} flash with text '#{expected_message}'
      but found #{actual.all("[class^='flash-']").map(&:text)}
    MESSAGE
  end

  def none_message
    <<~MESSAGE.squish
      expected to find #{expected_type} flash with text '#{expected_message}'
      but found no flash messages
    MESSAGE
  end

  def expected_selector
    ".flash-#{expected_type}"
  end
end

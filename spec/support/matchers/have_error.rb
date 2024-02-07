# frozen_string_literal: true

class Matchers::HaveError
  attr_reader :actual, :expected_message

  ERROR_SELECTOR = ".error-explanation li"

  def initialize(expected_message)
    @expected_message = expected_message
  end

  def matches?(actual)
    @actual = actual

    actual_message == expected_message
  end

  def actual_message
    actual.native.attribute("validationMessage")
  end

  def failure_message
    <<~MESSAGE.squish
      expected to find error with text #{expected_message} but found
      #{actual_message}
    MESSAGE
  end
end

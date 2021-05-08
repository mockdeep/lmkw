# frozen_string_literal: true

class Matchers::HaveCheck
  class MemoizedElement
    attr_accessor :memoized_results, :element

    LITERAL_CLASSES = [FalseClass, TrueClass, String].freeze

    def initialize(element)
      self.element = element
      self.memoized_results = Hash.new { |hash, key| hash[key] = {} }
    end

    def method_missing(method_name, *args, **kwargs)
      super unless element.respond_to?(method_name)

      memoized_results[method_name].fetch([args, kwargs]) do
        memoize(element.public_send(method_name, *args, **kwargs))
      end
    end

    def respond_to_missing?(method_name)
      element.respond_to?(method_name) || super
    end

    private

    def memoize(item)
      case item
      when *LITERAL_CLASSES
        item
      when Capybara::Node::Element
        MemoizedElement.new(item)
      when Capybara::Result
        item.map(&method(:memoize))
      else
        raise ArgumentError, "don't know how to memoize #{item.class}"
      end
    end
  end

  attr_accessor :element, :expected_name

  NAME_SELECTOR = ".card h3"

  def initialize(expected_name)
    self.expected_name = expected_name
  end

  def matches?(page)
    self.element = MemoizedElement.new(page)
    has_name?
  end

  def failure_message
    no_check_with_name_message
  end

  private

  def no_check_with_name_message
    <<~MESSAGE.squish
      expected to find check with name "#{expected_name}" but found checks
      with names: #{element.all(NAME_SELECTOR).map(&:text)}
    MESSAGE
  end

  def has_name?
    element.has_selector?(NAME_SELECTOR, text: expected_name)
  end
end

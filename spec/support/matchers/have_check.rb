# frozen_string_literal: true

module Matchers
  class HaveCheck
    class MemoizedElement
      attr_accessor :memoized_results, :element

      LITERAL_CLASSES = [FalseClass, TrueClass, String].freeze

      def initialize(element)
        self.element = element
        self.memoized_results = Hash.new { |hash, key| hash[key] = {} }
      end

      def method_missing(method_name, *args)
        super unless element.respond_to?(method_name)

        memoized_results[method_name].fetch(args) do
          memoize(element.public_send(method_name, *args))
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

    attr_accessor :page, :expected_name, :expected_text

    def initialize(expected_name, text:)
      self.expected_name = expected_name
      self.expected_text = text
    end

    def matches?(page)
      self.page = MemoizedElement.new(page)
      has_name? && has_text?
    end

    def failure_message
      if !has_name?
        no_check_with_name_message
      elsif !has_text?
        check_has_wrong_text_message
      end
    end

    private

    def no_check_with_name_message
      <<~MESSAGE.squish
        expected to find check with name "#{expected_name}" but found checks
        with names: #{page.all("h3").map(&:text)}
      MESSAGE
    end

    def check_has_wrong_text_message
      <<~MESSAGE.squish
        expected check with name "#{expected_name}" to have text
        "#{expected_text}" but had "#{check.find("p").text}"
      MESSAGE
    end

    def has_name?
      page.has_selector?(".check > h3", text: expected_name)
    end

    def has_text?
      check.has_selector?("p", text: expected_text)
    end

    def check
      page.find(".check > h3", text: expected_name).find(:xpath, "..")
    end
  end
end
# frozen_string_literal: true

module Page
  class Check
    attr_accessor :element

    def initialize(element)
      self.element = element
    end

    def delete_icon
      element.find(".fa-trash-alt")
    end
  end
end

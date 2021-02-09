# frozen_string_literal: true

module Page
  class Check
    attr_accessor :element

    def self.find(page, check)
      new(page.find(".card", text: check.name))
    end

    def initialize(element)
      self.element = element
    end

    def delete_icon
      element.find(".fa-trash-alt")
    end

    def edit_icon
      element.find(".fa-pen")
    end

    def refresh_icon
      element.find(".fa-sync-alt")
    end
  end
end

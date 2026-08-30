# frozen_string_literal: true

class Components::Icon < Components::Base
  def initialize(style, name, **attributes)
    extra_class = attributes.delete(:class)

    @classes = [style, "fa-#{name}", extra_class].compact
    @attributes = attributes
  end

  def view_template
    i(class: @classes, **@attributes)
  end
end

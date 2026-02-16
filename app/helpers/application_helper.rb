# frozen_string_literal: true

module ApplicationHelper
  def icon(style, name, **options)
    tag.i(class: [style, "fa-#{name}", options[:class]])
  end
end

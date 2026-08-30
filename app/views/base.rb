# frozen_string_literal: true

class Views::Base < Components::Base
  # Every page renders inside the application chrome, so Rails' own layout
  # mechanism is switched off in ApplicationController.
  def around_template
    render(Components::Layout.new) { super }
  end

  # More caching options at https://www.phlex.fun/components/caching
  def cache_store = Rails.cache
end

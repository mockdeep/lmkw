# frozen_string_literal: true

class Views::Base < Components::Base
  # More caching options at https://www.phlex.fun/components/caching
  def cache_store = Rails.cache
end

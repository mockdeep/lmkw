# frozen_string_literal: true

class Check::Manual::AnyCount < Check
  include Rails.application.routes.url_helpers

  STEPS = ["name"].freeze

  def next_step
    STEPS.find { |step| public_send(step).nil? }
  end

  def service
    "manual"
  end

  def icon
    ["fas", "exclamation"]
  end

  def manual?
    true
  end

  def url
    new_check_count_path(self)
  end
end

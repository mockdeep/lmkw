# frozen_string_literal: true

class Check::RunAllOutdated
  include JunkDrawer::Callable

  def call
    stale_checks.find_each do |check|
      CallableJob.perform_later("Check::Refresh", check)
    end
  end

  private

  def stale_checks
    Check.last_counted_before(5.minutes.ago).preload(:integration, :target)
  end
end

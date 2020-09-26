# frozen_string_literal: true

class ChecksController < ApplicationController
  def index
    refresh_checks
    render(locals: { checks: current_user.checks })
  end

  def new; end

  private

  def refresh_checks
    current_user.checks.each(&:refresh)
  end
end

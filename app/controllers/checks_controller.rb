# frozen_string_literal: true

class ChecksController < ApplicationController
  def index
    render(locals: { checks: current_user.checks })
  end

  def new; end
end

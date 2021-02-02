# frozen_string_literal: true

class ChecksController < ApplicationController
  def index
    render(locals: { checks: current_user.checks })
  end

  def new; end

  def destroy
    check = current_user.checks.find(params[:id])
    check.destroy!

    flash[:success] = "Check deleted"
    redirect_to(checks_path)
  end
end

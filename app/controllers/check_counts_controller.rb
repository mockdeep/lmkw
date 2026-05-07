# frozen_string_literal: true

class CheckCountsController < ApplicationController
  def new
    check = current_user.checks.find(params[:check_id])

    render(locals: { check:, count: Count.new })
  end

  def create
    count = check.counts.new(count_params)

    if count.save
      handle_save_success(count)
    else
      flash.now[:error] = t(".error")
      render(:new, locals: { check:, count: })
    end
  end

  private

  def handle_save_success(count)
    check.update!(latest_count: count)
    flash[:success] = t(".success")
    redirect_to(checks_path)
  end

  def check
    @check ||= current_user.checks.find(params[:check_id])
  end

  def count_params
    params.expect(count: [:value])
  end
end

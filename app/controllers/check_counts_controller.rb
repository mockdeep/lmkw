# frozen_string_literal: true

class CheckCountsController < ApplicationController
  def new
    check = current_user.checks.find(params[:check_id])

    render(locals: { check: check, count: CheckCount.new })
  end

  def create
    count = check.counts.new(count_params)

    if count.save
      flash[:success] = "Count updated"
      redirect_to(checks_path)
    else
      flash.now[:error] = "Unable to update count"
      render(:new, locals: { check: check, count: count })
    end
  end

  private

  def check
    @check ||= current_user.checks.find(params[:check_id])
  end

  def count_params
    params.require(:check_count).permit(:value)
  end
end

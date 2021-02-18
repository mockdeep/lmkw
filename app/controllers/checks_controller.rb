# frozen_string_literal: true

class ChecksController < ApplicationController
  def index
    render(
      locals: {
        checks: current_user.checks,
        unreached_goal_targets: current_user.targets.unreached_goal,
      },
    )
  end

  def new; end

  def edit
    render(locals: { check: find_check(params[:id]) })
  end

  def update
    check = find_check(params[:id])
    if check.update(check_params)
      flash[:success] = "Check updated"
      redirect_to(checks_path)
    else
      flash.now[:error] = "Unable to update check"
      render(:edit, locals: { check: check })
    end
  end

  def destroy
    find_check(params[:id]).destroy!

    flash[:success] = "Check deleted"
    redirect_to(checks_path)
  end

  private

  def target_attributes
    [:value, :id, :delta, :goal_value]
  end

  def check_params
    params
      .require(:check)
      .permit(:name, :refresh, target_attributes: target_attributes)
  end

  def find_check(id)
    current_user.checks.find(id)
  end
end

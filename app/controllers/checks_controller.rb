# frozen_string_literal: true

class ChecksController < ApplicationController
  def index
    checks = current_user.checks.preload(:latest_count, :target, :integration)
    targets = current_user.targets.unreached_goal

    render(locals: { checks:, unreached_goal_targets: targets })
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
      render(:edit, locals: { check: })
    end
  end

  def destroy
    Check::Destroy.call(find_check(params[:id]))

    flash[:success] = "Check deleted"
    redirect_to(checks_path)
  end

  private

  def target_attributes
    [:value, :id, :delta, :goal_value]
  end

  def check_params
    params.require(:check).permit(:name, :refresh, target_attributes:)
  end

  def find_check(id)
    current_user.checks.preload(:integration, :target).find(id)
  end
end

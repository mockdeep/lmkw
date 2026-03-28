# frozen_string_literal: true

class ChecksController < ApplicationController
  VALID_STATES = ["complete", "incomplete"].freeze

  def index
    checks = current_user.checks.preload(:latest_count, :target, :integration)
    targets = current_user.targets.unreached_goal

    render(locals: { checks:, unreached_goal_targets: targets })
  end

  def show
    check = find_check(params[:id])
    return redirect_not_trello unless check.is_a?(Check::Trello::ListHasCards)

    render(locals: { check:, cards: check.cards })
  rescue Trello::ApiError
    redirect_to(checks_path, alert: trello_cards_error)
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

  def update_checklist_item
    check = find_check(params[:id])
    unless check.is_a?(Check::Trello::ListHasCards)
      return head(:unprocessable_content)
    end

    return head(:unprocessable_content) if VALID_STATES.exclude?(params[:state])

    check.update_checklist_item(**checklist_item_params)
    head(:ok)
  rescue Trello::ApiError
    head(:service_unavailable)
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
    params.expect(check: [:name, :refresh, { target_attributes: }])
  end

  def find_check(id)
    current_user.checks.preload(:integration, :target).find(id)
  end

  def checklist_item_params
    {
      card_id: params[:cardId],
      item_id: params[:itemId],
      state: params[:state],
    }
  end

  def redirect_not_trello
    redirect_to(
      checks_path,
      alert: "Details view is only available for Trello checks",
    )
  end

  def trello_cards_error
    "Could not load Trello cards. Check your Trello connection and try again."
  end
end

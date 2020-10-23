# frozen_string_literal: true

class WelcomeController < ApplicationController
  skip_before_action(:authenticate_user)
  before_action(:redirect_if_logged_in)

  private

  def redirect_if_logged_in
    redirect_to(checks_path) if current_user.logged_in?
  end
end

# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action(:authenticate_user, only: [:new, :create])

  def new; end

  def create
    user = User::FindBy.call(email: session_params[:email])
    if user.authenticate(session_params[:password])
      log_in(user)
      redirect_to(checks_path)
    else
      flash.now[:error] = t(".error")
      render(:new)
    end
  end

  def destroy
    log_out
    redirect_to(root_path)
  end

  private

  def session_params
    params.expect(session: [:email, :password])
  end
end

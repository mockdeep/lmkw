# frozen_string_literal: true

class Target::RefreshesController < ApplicationController
  def create
    if params[:checks] == "all"
      Target::RefreshAll.call(current_user)
    else
      Target::RefreshOne.call(current_user)
    end

    redirect_to(checks_path)
  end
end

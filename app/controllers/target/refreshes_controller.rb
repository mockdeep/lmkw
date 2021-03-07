# frozen_string_literal: true

module Target
  class RefreshesController < ApplicationController
    def create
      if params[:checks] == "all"
        Check::Target::RefreshAll.call(current_user)
      else
        Check::Target::RefreshOne.call(current_user)
      end

      redirect_to(checks_path)
    end
  end
end

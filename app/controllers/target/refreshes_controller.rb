# frozen_string_literal: true

module Target
  class RefreshesController < ApplicationController
    def create
      Check::Target::RefreshAll.call(current_user)

      redirect_to(checks_path)
    end
  end
end

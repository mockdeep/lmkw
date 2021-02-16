# frozen_string_literal: true

class ManualIntegrationsController < ApplicationController
  def new
    integration = current_user.integrations.manual.first_or_create!
    redirect_to(new_manual_integration_check_path(integration))
  end
end

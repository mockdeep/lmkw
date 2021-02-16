# frozen_string_literal: true

require "rails_helper"

RSpec.describe ManualIntegrationsController, type: :request do
  describe "#new" do
    it "creates a manual integration for the user when not existing" do
      user = create_user
      login_as(user)

      expect { get(new_manual_integration_path) }
        .to change(user.integrations, :count).by(1)
    end

    it "does not create a manual integration when the user already has one" do
      integration = create_manual_integration
      user = integration.user
      login_as(user)

      expect { get(new_manual_integration_path) }
        .not_to change(user.integrations, :count)
    end

    it "redirects to the new check page for the integration" do
      integration = create_manual_integration
      login_as(integration.user)

      get(new_manual_integration_path)

      path = new_manual_integration_check_path(integration)
      expect(response).to redirect_to(path)
    end
  end
end

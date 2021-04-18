# frozen_string_literal: true

require "rails_helper"

RSpec.describe ManualChecksController, type: :request do
  describe "#new" do
    it "renders the new check page" do
      integration = create(:manual_integration)
      login_as(integration.user)

      get(new_manual_integration_check_path(integration))

      expect(rendered).to have_content("Name your check")
    end
  end

  describe "#create" do
    it "creates a new check" do
      integration = create(:manual_integration)
      login_as(integration.user)

      path = manual_integration_checks_path(integration)
      expect { post(path, params: { check: { name: "a new check" } }) }
        .to change(integration.checks, :count).by(1)
    end

    it "refreshes the check" do
      integration = create(:manual_integration)
      login_as(integration.user)

      params = { check: { name: "a new check" } }
      path = manual_integration_checks_path(integration)

      expect { post(path, params: params) }.to invoke(:call).on(Check::Refresh)
    end

    it "redirects to checks/index" do
      integration = create(:manual_integration)
      login_as(integration.user)

      params = { check: { name: "a new check" } }
      post(manual_integration_checks_path(integration), params: params)

      expect(response).to redirect_to(checks_path)
    end
  end
end

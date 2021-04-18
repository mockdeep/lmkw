# frozen_string_literal: true

require "rails_helper"

RSpec.describe GithubIntegrationsController do
  describe "#new" do
    it "redirects to the new check page when integration already exists" do
      integration = create(:github_integration)
      login_as(integration.user)

      get(:new)

      expected_path = new_github_integration_check_path(integration)
      expect(response).to redirect_to(expected_path)
    end

    it "renders the new page when integration does not exist" do
      login_as(create(:user))

      get(:new)

      expect(rendered).to have_link("Authenticate with GitHub")
    end
  end

  describe "#create" do
    it "raises an error when :state parameter does not match" do
      session[:user_id] = create(:user).id
      session[:github_state] = "baa"

      expect { get(:create, params: { state: "boo" }) }
        .to raise_error(ActionController::RoutingError, "Not Found")
    end
  end
end

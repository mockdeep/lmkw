# frozen_string_literal: true

require "rails_helper"

RSpec.describe TrelloIntegrationsController do
  describe "#new" do
    it "redirects to the new check page when integration already exists" do
      integration = create_integration(:trello)
      login_as(integration.user)

      get(:new)

      expected_path = new_trello_integration_check_path(integration)
      expect(response).to redirect_to(expected_path)
    end

    it "renders the new page when integration does not exist" do
      login_as(create(:user))

      get(:new)

      expect(rendered).to have_link("Authenticate with Trello")
    end
  end
end

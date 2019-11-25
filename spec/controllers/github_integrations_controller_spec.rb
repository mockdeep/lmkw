# frozen_string_literal: true

require "rails_helper"

RSpec.describe GithubIntegrationsController do
  describe "#create" do
    user_params = {
      email: "demo@exampoo.com",
      password: "super-secure",
      password_confirmation: "super-secure",
    }

    it "raises an error when :state parameter does not match" do
      session[:user_id] = User.create!(user_params).id
      session[:github_state] = "baa"

      expect { get(:create, params: { state: "boo" }) }
        .to raise_error(ActionController::RoutingError, "Not Found")
    end
  end
end

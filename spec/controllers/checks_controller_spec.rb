# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChecksController, type: :controller do
  user_params = {
    email: "demo@exampoo.com",
    password: "super-secure",
    password_confirmation: "super-secure",
  }

  describe "#index" do
    it "renders the checks page" do
      session[:user_id] = User.create!(user_params).id

      get(:index)

      expect(response.body).to include("Checks")
    end
  end
end

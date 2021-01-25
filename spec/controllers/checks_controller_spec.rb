# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChecksController, type: :controller do
  describe "#index" do
    it "renders the checks page" do
      session[:user_id] = User.create!(user_params).id

      get(:index)

      expect(response.body).to include("Checks")
    end
  end
end

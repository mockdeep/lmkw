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

  describe "#destroy" do
    it "deletes the check" do
      check = create_check
      login_as(check.user)

      delete(:destroy, params: { id: check.id })

      expect(Check.find_by(id: check.id)).to be_nil
    end

    it "flashes a success message" do
      check = create_check
      login_as(check.user)

      delete(:destroy, params: { id: check.id })

      expect(flash[:success]).to eq("Check deleted")
    end

    it "redirects to checks/index" do
      check = create_check
      login_as(check.user)

      delete(:destroy, params: { id: check.id })

      expect(response).to redirect_to(checks_path)
    end

    it "raises an error when user cannot access check" do
      check = create_check
      login_as(create_user)

      expect { delete(:destroy, params: { id: check.id }) }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

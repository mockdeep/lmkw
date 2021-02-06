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

  describe "#edit" do
    it "renders the edit page for a check" do
      check = create_check
      login_as(check.user)

      get(:edit, params: { id: check.id })

      expect(rendered).to have_content("Editing Check: #{check.name}")
    end
  end

  describe "#update" do
    context "when params are valid" do
      it "updates the check" do
        check = create_check
        login_as(check.user)

        put(:update, params: { id: check.id, check: { target: 5 } })

        expect(check.reload.target).to eq(5)
      end

      it "redirects to checks/index" do
        check = create_check
        login_as(check.user)

        put(:update, params: { id: check.id, check: { target: 5 } })

        expect(response).to redirect_to(checks_path)
      end

      it "flashes a success message" do
        check = create_check
        login_as(check.user)

        put(:update, params: { id: check.id, check: { target: 5 } })

        expect(flash[:success]).to eq("Check updated")
      end
    end

    context "when params are invalid" do
      it "flashes an error message" do
        check = create_check
        login_as(check.user)

        put(:update, params: { id: check.id, check: { target: "" } })

        expect(response.body).to include("Unable to update check")
      end

      it "renders the edit view" do
        check = create_check
        login_as(check.user)

        put(:update, params: { id: check.id, check: { target: "" } })

        expect(rendered).to have_content("Editing Check: #{check.name}")
      end
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

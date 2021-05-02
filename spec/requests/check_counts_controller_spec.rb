# frozen_string_literal: true

require "rails_helper"

RSpec.describe CheckCountsController, type: :request do
  describe "#new" do
    it "renders the new count form" do
      check = create(:check)
      login_as(default_user)

      get(new_check_count_path(check), params: { check_id: check.id })

      expect(rendered).to have_content("Editing Count for Check:")
    end
  end

  describe "#create" do
    context "when params are valid" do
      it "creates a new count" do
        check = create(:check)
        login_as(default_user)
        params = { count: { value: 5 } }

        expect { post(check_counts_path(check), params: params) }
          .to change { check.reload.last_value }.from(nil).to(5)
      end

      it "flashes a success message" do
        check = create(:check)
        login_as(default_user)
        params = { count: { value: 5 } }

        post(check_counts_path(check), params: params)

        expect(flash[:success]).to eq("Count updated")
      end

      it "redirects to checks/index" do
        check = create(:check)
        login_as(default_user)
        params = { count: { value: 5 } }

        post(check_counts_path(check), params: params)

        expect(response).to redirect_to(checks_path)
      end
    end

    context "when params are invalid" do
      it "flashes an error message" do
        check = create(:check)
        login_as(default_user)
        params = { count: { value: nil } }

        post(check_counts_path(check), params: params)

        expect(rendered).to have_content("Unable to update count")
      end

      it "renders the new count form" do
        check = create(:check)
        login_as(default_user)
        params = { count: { value: nil } }

        post(check_counts_path(check), params: params)

        expect(rendered).to have_content("Editing Count for Check:")
      end
    end
  end
end

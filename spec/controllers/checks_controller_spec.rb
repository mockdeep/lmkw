# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChecksController do
  describe "#index" do
    it "renders the checks page" do
      login_as(create(:user))

      get(:index)

      expect(rendered).to have_content("Checks")
    end
  end

  it "displays Refresh X Targets when multiple targets have unreached goal" do
    create_pair(:check, value: 3, target_value: 5, target_delta: 5)
    login_as(default_user)

    get(:index)

    expect(rendered).to have_button("Refresh All 2 Targets")
  end

  it "displays Refresh 1 Target when targets have unreached goal" do
    create(:check, value: 3, target_value: 5, target_delta: 5)
    login_as(default_user)

    get(:index)

    expect(rendered).to have_button("Refresh 1 Target")
  end

  it "does not display Refresh 1 Targets when all targets match goal" do
    create(:check, value: 0)
    login_as(default_user)

    get(:index)

    expect(rendered).to have_no_button("Refresh 1 Targets")
  end

  describe "#edit" do
    it "renders the edit page for a check" do
      check = create(:check)
      login_as(default_user)

      get(:edit, params: { id: check.id })

      expect(rendered).to have_content("Editing Check: #{check.name}")
    end
  end

  describe "#update" do
    context "when params are valid" do
      it "updates the check" do
        check = create(:check)
        login_as(default_user)

        check_params = { target_attributes: { value: 5 } }
        expect { put(:update, params: { id: check.id, check: check_params }) }
          .to change_record(check.target, :value).from(0).to(5)
      end

      it "redirects to checks/index" do
        check = create(:check)
        login_as(default_user)

        check_params = { target_attributes: { value: 5 } }
        put(:update, params: { id: check.id, check: check_params })

        expect(response).to redirect_to(checks_path)
      end

      it "flashes a success message" do
        check = create(:check)
        login_as(default_user)

        check_params = { target_attributes: { value: 5 } }
        put(:update, params: { id: check.id, check: check_params })

        expect(flash[:success]).to eq("Check updated")
      end
    end

    context "when params are invalid" do
      it "flashes an error message" do
        check = create(:check)
        login_as(default_user)

        check_params = { target_attributes: { value: "" } }
        put(:update, params: { id: check.id, check: check_params })

        expect(response.body).to include("Unable to update check")
      end

      it "renders the edit view" do
        check = create(:check)
        login_as(default_user)

        check_params = { target_attributes: { value: "" } }
        put(:update, params: { id: check.id, check: check_params })

        expect(rendered).to have_content("Editing Check: #{check.name}")
      end
    end
  end

  describe "#destroy" do
    it "deletes the check" do
      check = create(:check)
      login_as(default_user)

      delete(:destroy, params: { id: check.id })

      expect(Check.find_by(id: check.id)).to be_nil
    end

    it "deletes associated records" do
      check = create(:check, value: 5)
      login_as(default_user)

      delete(:destroy, params: { id: check.id })

      expect(Count.where(check_id: check.id)).to be_empty
    end

    it "flashes a success message" do
      check = create(:check)
      login_as(default_user)

      delete(:destroy, params: { id: check.id })

      expect(flash[:success]).to eq("Check deleted")
    end

    it "redirects to checks/index" do
      check = create(:check)
      login_as(default_user)

      delete(:destroy, params: { id: check.id })

      expect(response).to redirect_to(checks_path)
    end

    it "raises an error when user cannot access check" do
      check = create(:check)
      login_as(create(:user))

      expect { delete(:destroy, params: { id: check.id }) }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

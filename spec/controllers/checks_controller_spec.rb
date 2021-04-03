# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChecksController, type: :controller do
  describe "#index" do
    it "renders the checks page" do
      login_as(create_user)

      get(:index)

      expect(rendered).to have_content("Checks")
    end
  end

  it "displays Refresh All Targets when targets have unreached goal" do
    check = create_check(counts: [{ value: 3 }], target: { value: 5, delta: 5 })
    login_as(check.user)

    get(:index)

    expect(rendered).to have_button("Refresh All Targets")
  end

  it "does not display Refresh All Targets when all targets match goal" do
    check = create_check(counts: [{ value: 0 }])
    login_as(check.user)

    get(:index)

    expect(rendered).to have_no_button("Refresh All Targets")
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

        check_params = { target_attributes: { value: 5 } }
        expect { put(:update, params: { id: check.id, check: check_params }) }
          .to change_record(check.target, :value).from(0).to(5)
      end

      it "redirects to checks/index" do
        check = create_check
        login_as(check.user)

        check_params = { target_attributes: { value: 5 } }
        put(:update, params: { id: check.id, check: check_params })

        expect(response).to redirect_to(checks_path)
      end

      it "flashes a success message" do
        check = create_check
        login_as(check.user)

        check_params = { target_attributes: { value: 5 } }
        put(:update, params: { id: check.id, check: check_params })

        expect(flash[:success]).to eq("Check updated")
      end
    end

    context "when params are invalid" do
      it "flashes an error message" do
        check = create_check
        login_as(check.user)

        check_params = { target_attributes: { value: "" } }
        put(:update, params: { id: check.id, check: check_params })

        expect(response.body).to include("Unable to update check")
      end

      it "renders the edit view" do
        check = create_check
        login_as(check.user)

        check_params = { target_attributes: { value: "" } }
        put(:update, params: { id: check.id, check: check_params })

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

    it "deletes associated records" do
      check = create_check(counts: [{ value: 5 }])
      login_as(check.user)

      delete(:destroy, params: { id: check.id })

      expect(CheckCount.where(check_id: check.id)).to be_empty
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

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

  describe "#show" do
    def trello_check
      integration = create(:trello_integration)
      Check::Trello::ListHasCards.create!(
        integration:,
        name: "My Check",
        board_id: "b1",
        list_id: "l1",
        user: integration.user,
        target_attributes: { value: 0, delta: 0 },
      )
    end

    it "renders the checklist view for Trello checks" do
      check = trello_check
      login_as(check.user)
      stub_request(:get, /trello\.com.*cards/).to_return(body: [].to_json)
      get(:show, params: { id: check.id })
      expect(rendered).to have_content(check.name)
    end

    context "with a non-Trello check" do
      before do
        login_as(default_user)
        get(:show, params: { id: create(:check).id })
      end

      it { expect(response).to redirect_to(checks_path) }

      it "shows a Trello-specific alert" do
        msg = "Details view is only available for Trello checks"
        expect(flash[:alert]).to eq(msg)
      end
    end

    context "when Trello API fails" do
      before do
        check = trello_check
        login_as(check.user)
        stub_request(:get, /trello\.com.*cards/)
          .to_return(status: 500, body: "error")
        get(:show, params: { id: check.id })
      end

      it { expect(response).to redirect_to(checks_path) }
      it { expect(flash[:alert]).to include("Could not load Trello cards") }
    end
  end

  describe "#update_checklist_item" do
    def trello_check
      integration = create(:trello_integration)
      Check::Trello::ListHasCards.create!(
        integration:,
        name: "My Check",
        board_id: "b1",
        list_id: "l1",
        user: integration.user,
        target_attributes: { value: 0, delta: 0 },
      )
    end

    def item_params
      { cardId: "c1", itemId: "i1", state: "complete" }
    end

    def update_url_pattern
      %r{api\.trello\.com.*cards/c1/checkItem/i1}
    end

    def bad_state_params(check)
      { id: check.id, cardId: "c1", itemId: "i1", state: "bad" }
    end

    def stub_put_api_failure
      stub_request(:put, update_url_pattern)
        .to_return(status: 500, body: "error")
    end

    it "returns ok for Trello checks" do
      check = trello_check
      login_as(check.user)
      stub_request(:put, update_url_pattern).to_return(body: {}.to_json)
      put(:update_checklist_item, params: { id: check.id, **item_params })
      expect(response).to have_http_status(:ok)
    end

    it "returns unprocessable_content for non-Trello checks" do
      check = create(:check)
      login_as(default_user)
      put(:update_checklist_item, params: { id: check.id, **item_params })
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "returns unprocessable_content for an invalid state" do
      check = trello_check
      login_as(check.user)
      put(:update_checklist_item, params: bad_state_params(check))
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "returns service_unavailable when Trello API fails" do
      check = trello_check
      login_as(check.user)
      stub_put_api_failure
      put(:update_checklist_item, params: { id: check.id, **item_params })
      expect(response).to have_http_status(:service_unavailable)
    end
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

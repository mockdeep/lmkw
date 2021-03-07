# frozen_string_literal: true

require "rails_helper"

RSpec.describe Target::RefreshesController do
  describe "#create" do
    context "when checks: 'all'" do
      it "refreshes all unreached goal targets" do
        target = create(:target, value: 5, delta: 5)
        login_as(target.user)

        expect { post(target_refreshes_path(checks: "all")) }
          .to change_record(target, :value).from(5).to(0)
      end

      it "does not refresh targets that match their goal" do
        target = create(:target, value: 5, goal_value: 5, delta: 5)
        login_as(target.user)

        expect { post(target_refreshes_path(checks: "all")) }
          .to not_change_record(target, :value).from(5)
      end

      it "redirects to checks/index" do
        login_as(create(:user))

        post(target_refreshes_path(checks: "all"))

        expect(response).to redirect_to(checks_path)
      end
    end

    context "when checks: 'one'" do
      it "refreshes a single unreached goal target" do
        target = create(:target, value: 5, delta: 5)
        login_as(target.user)

        expect { post(target_refreshes_path(checks: "one")) }
          .to change_record(target, :value).from(5).to(0)
      end

      it "does not refresh a target that matches its goal" do
        target = create(:target, value: 5, goal_value: 5, delta: 5)
        login_as(target.user)

        expect { post(target_refreshes_path(checks: "one")) }
          .to not_change_record(target, :value).from(5)
      end

      it "redirects to checks/index" do
        login_as(create(:user))

        post(target_refreshes_path(checks: "one"))

        expect(response).to redirect_to(checks_path)
      end
    end
  end
end

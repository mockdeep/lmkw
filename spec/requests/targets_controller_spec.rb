# frozen_string_literal: true

require "rails_helper"

RSpec.describe TargetsController do
  describe "#update" do
    it "refreshes unreached goal targets" do
      target = create_target(value: 5, delta: 5)
      login_as(target.user)

      expect { patch(targets_path) }
        .to change_record(target, :value).from(5).to(0)
    end

    it "does not refresh targets that match their goal" do
      target = create_target(value: 5, goal_value: 5, delta: 5)
      login_as(target.user)

      expect { patch(targets_path) }
        .to not_change_record(target, :value).from(5)
    end

    it "redirects to checks/index" do
      login_as(create_user)

      patch(targets_path)

      expect(response).to redirect_to(checks_path)
    end
  end
end

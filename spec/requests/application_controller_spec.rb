# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController, type: :request do
  describe "#authenticate_user" do
    it "finds the user by session" do
      check = create_check
      login_as(check.user)

      params = { check_count: { value: 5 } }

      expect { post(check_counts_path(check), params: params) }
        .to change(check, :last_value).from(nil).to(5)
    end

    it "finds the user by API key" do
      check = create_check
      headers = api_key_headers(create_api_key(user: check.user))
      post_options = { params: { check_count: { value: 5 } }, headers: headers }

      expect { post(check_counts_path(check), **post_options) }
        .to change(check, :last_value).from(nil).to(5)
    end

    context "when user is not found" do
      it "does not reach the controller action" do
        check = create_check
        params = { check_count: { value: 5 } }

        expect { post(check_counts_path(check), params: params) }
          .not_to change(check, :last_value).from(nil)
      end

      it "redirects to new_session_path" do
        check = create_check
        params = { check_count: { value: 5 } }

        post(check_counts_path(check), params: params)

        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end

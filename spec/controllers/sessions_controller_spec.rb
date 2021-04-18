# frozen_string_literal: true

require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  def valid_create_params(user)
    { session: user.slice(:email, :password) }
  end

  def invalid_create_params
    { session: { email: "wrong@email", password: "wrong password" } }
  end

  describe "#new" do
    it "renders a new form" do
      get(:new)

      expect(response.body).to include("Log in to")
    end
  end

  describe "#create" do
    context "when user authenticates" do
      it "sets the user id in the session" do
        user = create(:user)

        post(:create, params: valid_create_params(user))

        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to the home page" do
        user = create(:user)

        post(:create, params: valid_create_params(user))

        expect(response).to redirect_to(checks_path)
      end
    end

    context "when user does not authenticate" do
      it "flashes an error" do
        create(:user)

        post(:create, params: invalid_create_params)

        expect(response.body).to include("Invalid email or password")
      end

      it "renders the new template" do
        create(:user)

        post(:create, params: invalid_create_params)

        expect(response.body).to include("Log in to")
      end
    end
  end

  describe "#destroy" do
    context "when user is not logged in" do
      it "redirects to log in page" do
        delete(:destroy)

        expect(response).to redirect_to(new_session_path)
      end

      it "does not clear the session" do
        session[:blah] = "boo"

        delete(:destroy)

        expect(session[:blah]).to eq("boo")
      end
    end

    it "signs out the user" do
      session[:user_id] = create(:user).id

      delete(:destroy)

      expect(session[:user_id]).to be(nil)
    end

    it "clears the session" do
      session[:user_id] = create(:user).id
      session[:blah] = "boo"

      delete(:destroy)

      expect(session[:blah]).to be(nil)
    end

    it "redirects to the home page" do
      user = create(:user)
      session[:user_id] = user.id

      delete(:destroy)

      expect(response).to redirect_to(root_path)
    end
  end
end

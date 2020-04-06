# frozen_string_literal: true

require "sinatra/base"

module FakeApi
  module Github
    class Server < Sinatra::Base
      enable(:sessions)
      class << self
        attr_accessor :return_url
      end

      get("/login/oauth/authorize") do
        session["state"] = params["state"]
        <<-HTML
          <form action="/session" accept-charset="UTF-8" method="post">
            <div class="auth-form-body mt-3">
              <label for="login_field">Username or email address</label>
              <input type="text" name="login" id="login_field" />

              <label for="password">Password</label>
              <input type="password" name="password" id="password" />

              <input type="submit" name="commit" value="Sign in" />
            </div>
          </form>
        HTML
      end

      post("/session") do
        state = session["state"]
        redirect("#{self.class.return_url}?code=some_code&state=#{state}")
      end
      run! if app_file == $PROGRAM_NAME
    end
  end
end

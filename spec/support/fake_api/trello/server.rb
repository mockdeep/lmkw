# frozen_string_literal: true

require "sinatra/base"

class FakeApi::Trello::Server < Sinatra::Base
  enable(:sessions)
  get("/1/authorize") do
    if params.key?("requestKey")
      <<-HTML
        <form method="POST" action="/1/token/approve">
          <input type="submit" class="deny" value="Deny">
          <input type="submit" name="approve" value="Allow">
        </form>
      HTML
    else
      session["return_url"] = params["returnUrl"]
      <<-HTML
        <a href='/login'>Log in</a>
      HTML
    end
  end

  get("/login") do
    <<-HTML
      <form method="POST">
        <label for="user">Email or Username</label>
        <input type="email" name="user" id="user">
        <input id="login" type="submit" value="Log in with Atlassian">
      </form>
    HTML
  end

  post("/login") do
    if params.key?("password")
      redirect("/1/authorize?requestKey=boo")
    else
      <<-HTML
        <form method="POST">
          <label for="password">Password</label>
          <input type="password" name="password" id="password">
          <input id="login" type="submit" value="Log in">
        </form>
      HTML
    end
  end

  post("/1/token/approve") do
    redirect("#{session["return_url"]}#token=fake-trello-token")
  end

  run! if app_file == $PROGRAM_NAME
end

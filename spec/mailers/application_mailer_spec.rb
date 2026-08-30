# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationMailer do
  it "wraps the html part in the Phlex layout" do
    part = Test::Mailer.hello.html_part

    expect(part.body.to_s).to include("<!doctype html>")
  end

  it "renders the view inside the layout body" do
    part = Test::Mailer.hello.html_part

    expect(part.body.to_s).to include("<body><p>hello body</p></body>")
  end

  it "declares the charset in the layout head" do
    part = Test::Mailer.hello.html_part

    expect(part.body.to_s).to include('<meta http-equiv="Content-Type"')
  end

  it "leaves the text part unwrapped" do
    part = Test::Mailer.hello.text_part

    expect(part.body.to_s.strip).to eq("plain body")
  end
end

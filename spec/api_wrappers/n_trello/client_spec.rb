# frozen_string_literal: true

require "rails_helper"

RSpec.describe NTrello::Client do
  describe ".authorize_url" do
    it "returns a URL to authorize Trello access" do
      return_url = "https://foobar.com/baz"
      trello_url = "trello.com/1/authorize"

      result = described_class.authorize_url(return_url:)

      expect(result).to include(CGI.escape(return_url)).and include(trello_url)
    end
  end

  describe "#boards" do
    it "returns boards" do
      fake_trello_client = instance_double(::Trello::Client)
      fake_member = instance_double(::Trello::Member, username: "boo")
      client = described_class.new(member_token: "blah")

      expect { client.boards }
        .to invoke(:new).on(::Trello::Client).and_return(fake_trello_client)
        .and invoke(:find).on(fake_trello_client).with(:member, :me)
        .and_return(fake_member)
        .and invoke(:get).on(fake_trello_client)
        .with("/members/boo/boards?filter=open")
        .and_return(String.new("{}"))
    end
  end

  describe "#find" do
    it "delegates to the trello client" do
      fake_trello_client = instance_double(::Trello::Client)
      client = described_class.new(member_token: "blah")

      expect { client.find("foo", "bar") }
        .to invoke(:new).on(::Trello::Client).and_return(fake_trello_client)
        .and invoke(:find).on(fake_trello_client).with("foo", "bar")
    end
  end
end

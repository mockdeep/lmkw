# frozen_string_literal: true

require "rails_helper"

RSpec.describe NTrello::Client do
  describe ".authorize_url" do
    it "returns a URL to authorize Trello access" do
      return_url = "https://foobar.com/baz"
      developer_public_key = described_class.developer_public_key

      result = described_class.authorize_url(return_url:)

      expected = "https://trello.com/1/authorize?callback_method=fragment&expiration=never&key=#{developer_public_key}&name=LetMeKnowWhen&response_type=fragment&return_url=https%3A%2F%2Ffoobar.com%2Fbaz&scope=read"
      expect(result).to eq(expected)
    end
  end

  describe "#boards" do
    def response(uri:, body:)
      body = String.new(body)
      HTTP::Response.new(status: 200, version: "1.1", uri:, body:)
    end

    it "returns boards" do
      fake_trello_client = instance_double(::Trello::Client)
      fake_member = instance_double(::Trello::Member, username: "boo")
      client = described_class.new(member_token: "blah")
      developer_public_key = described_class.developer_public_key
      params = { filter: "open", key: developer_public_key, token: "blah" }

      expected_url = "https://api.trello.com/1/members/boo/boards?#{params.to_query}"
      expect { client.boards }
        .to invoke(:new).on(::Trello::Client).and_return(fake_trello_client)
        .and invoke(:find).on(fake_trello_client).with(:member, :me)
        .and_return(fake_member)
        .and invoke(:get).on(HTTP)
        .with(expected_url)
        .and_return(response(uri: expected_url, body: "{}"))
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

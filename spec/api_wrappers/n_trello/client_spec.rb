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

  describe "#fetch_boards" do
    def response(uri:, body:)
      body = String.new(body)
      HTTP::Response.new(status: 200, version: "1.1", uri:, body:)
    end

    it "returns boards" do
      client = described_class.new(member_token: "blah")
      developer_public_key = described_class.developer_public_key
      auth_params = { key: developer_public_key, token: "blah" }
      params = { filter: "open", **auth_params }

      boards_url = "https://api.trello.com/1/members/boo/boards?#{params.to_query}"
      member_url = "https://api.trello.com/1/members/me?#{auth_params.to_query}"
      stub_request(:get, member_url)
        .to_return(body: { username: "boo" }.to_json)
      stub_request(:get, boards_url).to_return(body: [].to_json)

      expect(client.fetch_boards).to eq([])
    end
  end

  describe "#fetch_board" do
    it "returns the board with the given id" do
      client = described_class.new(member_token: "blah")
      stub_request(:get, "https://api.trello.com/1/boards/3?key=b151cfc72ed56c15f13296ffbaf96194&token=blah")
        .to_return(body: { id: 3, url: "/bloo", name: "bloo board" }.to_json)

      result = client.fetch_board(id: 3)

      expect(result.url).to eq("/bloo")
    end
  end

  describe "#fetch_lists" do
    it "returns lists with the given board id" do
      client = described_class.new(member_token: "blah")
      stub_request(:get, "https://api.trello.com/1/boards/3/lists?key=b151cfc72ed56c15f13296ffbaf96194&token=blah")
        .to_return(body: [{ id: 4, name: "list 1" }].to_json)

      result = client.fetch_lists(board_id: 3)

      expect(result.map(&:name)).to eq(["list 1"])
    end
  end

  describe "#fetch_cards" do
    it "returns cards with the given list id" do
      client = described_class.new(member_token: "blah")
      stub_request(:get, "https://api.trello.com/1/lists/5/cards?key=b151cfc72ed56c15f13296ffbaf96194&token=blah")
        .to_return(body: [{ id: 6, name: "card 6" }].to_json)

      result = client.fetch_cards(list_id: 5)

      expect(result.map(&:name)).to eq(["card 6"])
    end
  end
end

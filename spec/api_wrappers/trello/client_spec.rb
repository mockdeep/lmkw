# frozen_string_literal: true

require "rails_helper"

RSpec.describe Trello::Client do
  delegate :developer_public_key, to: :described_class

  def auth_params
    { key: developer_public_key, token: "blah" }
  end

  def boards_url
    params = { filter: "open", **auth_params }

    "https://api.trello.com/1/members/bo/boards?#{params.to_query}"
  end

  def member_url
    "https://api.trello.com/1/members/me?#{auth_params.to_query}"
  end

  describe ".authorize_url" do
    it "returns a URL to authorize Trello access" do
      return_url = "https://foobar.com/baz"

      result = described_class.authorize_url(return_url:)

      expected = "https://trello.com/1/authorize?callback_method=fragment&expiration=never&key=#{developer_public_key}&name=LetMeKnowWhen&response_type=fragment&return_url=https%3A%2F%2Ffoobar.com%2Fbaz&scope=read"
      expect(result).to eq(expected)
    end
  end

  describe "#fetch_boards" do
    it "returns boards" do
      client = described_class.new(member_token: "blah")

      stub_request(:get, member_url).to_return(body: { username: "bo" }.to_json)
      stub_request(:get, boards_url).to_return(body: [].to_json)

      expect(client.fetch_boards).to eq([])
    end
  end

  describe "#fetch_board" do
    it "returns the board with the given id" do
      client = described_class.new(member_token: "blah")
      stub_request(:get, "https://api.trello.com/1/boards/3?#{auth_params.to_query}")
        .to_return(body: { id: 3, url: "/bloo", name: "bloo board" }.to_json)

      result = client.fetch_board(id: 3)

      expect(result.url).to eq("/bloo")
    end
  end

  describe "#fetch_lists" do
    it "returns lists with the given board id" do
      client = described_class.new(member_token: "blah")
      stub_request(:get, "https://api.trello.com/1/boards/3/lists?#{auth_params.to_query}")
        .to_return(body: [{ id: 4, name: "list 1" }].to_json)

      result = client.fetch_lists(board_id: 3)

      expect(result.map(&:name)).to eq(["list 1"])
    end
  end

  describe "#fetch_cards" do
    it "returns cards with the given list id" do
      client = described_class.new(member_token: "blah")
      stub_request(:get, "https://api.trello.com/1/lists/5/cards?#{auth_params.to_query}")
        .to_return(body: [{ id: 6, name: "card 6" }].to_json)

      result = client.fetch_cards(list_id: 5)

      expect(result.map(&:name)).to eq(["card 6"])
    end
  end
end

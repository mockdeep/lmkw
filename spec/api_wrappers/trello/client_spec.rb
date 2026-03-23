# frozen_string_literal: true

require "rails_helper"

RSpec.describe Trello::Client do
  delegate :developer_public_key, to: :described_class

  def client
    described_class.new(member_token: "blah")
  end

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

      expected = "https://trello.com/1/authorize?callback_method=fragment&expiration=never&key=#{developer_public_key}&name=LetMeKnowWhen&response_type=fragment&return_url=https%3A%2F%2Ffoobar.com%2Fbaz&scope=read%2Cwrite"
      expect(result).to eq(expected)
    end
  end

  describe "#fetch_boards" do
    it "returns boards" do
      stub_request(:get, member_url).to_return(body: { username: "bo" }.to_json)
      stub_request(:get, boards_url).to_return(body: [].to_json)

      expect(client.fetch_boards).to eq([])
    end
  end

  describe "#fetch_board" do
    it "returns the board with the given id" do
      stub_request(:get, "https://api.trello.com/1/boards/3?#{auth_params.to_query}")
        .to_return(body: { id: 3, url: "/bloo", name: "bloo board" }.to_json)

      result = client.fetch_board(id: 3)

      expect(result.url).to eq("/bloo")
    end
  end

  describe "#fetch_lists" do
    it "returns lists with the given board id" do
      stub_request(:get, "https://api.trello.com/1/boards/3/lists?#{auth_params.to_query}")
        .to_return(body: [{ id: 4, name: "list 1" }].to_json)

      result = client.fetch_lists(board_id: 3)

      expect(result.map(&:name)).to eq(["list 1"])
    end
  end

  describe "#fetch_cards" do
    def unordered_checklists
      [
        { id: "cl2", name: "Second", pos: 20, checkItems: [] },
        { id: "cl1", name: "First", pos: 10, checkItems: [] },
      ]
    end

    def cards_url(list_id:)
      "https://api.trello.com/1/lists/#{list_id}/cards?checklists=all&#{auth_params.to_query}"
    end

    it "returns cards with the given list id" do
      stub_request(
        :get,
        cards_url(list_id: 5),
      ).to_return(body: [{ name: "card 6" }].to_json)
      expect(client.fetch_cards(list_id: 5).map(&:name)).to eq(["card 6"])
    end

    it "parses checklist data when present" do
      checklist = { id: "cl1", name: "Todo", pos: 0, checkItems: [] }
      stub_request(:get, cards_url(list_id: 5))
        .to_return(body: [{ checklists: [checklist] }].to_json)
      expect(client.fetch_cards(list_id: 5).first.checklists.length).to eq(1)
    end

    it "returns checklists ordered by position" do
      stub_request(:get, cards_url(list_id: 5))
        .to_return(body: [{ checklists: unordered_checklists }].to_json)
      result = client.fetch_cards(list_id: 5).first.checklists
      expect(result.map(&:name)).to eq(["First", "Second"])
    end

    it "raises Trello::ApiError on non-2xx response" do
      stub_request(:get, cards_url(list_id: 5)).to_return(
        status: 401,
        body: "Unauthorized",
      )
      expect { client.fetch_cards(list_id: 5) }.to raise_error(Trello::ApiError)
    end

    it "raises Trello::ApiError on network failure" do
      stub_request(:get, cards_url(list_id: 5)).to_raise(HTTP::ConnectionError)
      expect { client.fetch_cards(list_id: 5) }.to raise_error(Trello::ApiError)
    end
  end

  describe "#update_checklist_item" do
    def update_args
      { card_id: "c1", item_id: "i1", state: "complete" }
    end

    def update_url_pattern
      %r{api\.trello\.com.*cards/c1/checkItem/i1}
    end

    def update_query_params
      hash_including(
        "state" => "complete",
        "key" => developer_public_key,
        "token" => "blah",
      )
    end

    it "calls the correct URL with the correct params" do
      stub = stub_request(:put, update_url_pattern)
        .with(query: update_query_params)
        .to_return(body: {}.to_json)
      client.update_checklist_item(**update_args)
      expect(stub).to have_been_requested
    end

    it "raises Trello::ApiError on non-2xx response" do
      stub_request(:put, update_url_pattern).to_return(
        status: 401,
        body: "Unauthorized",
      )
      expect { client.update_checklist_item(**update_args) }.to raise_error(Trello::ApiError)
    end

    it "raises Trello::ApiError on network failure" do
      stub_request(:put, update_url_pattern).to_raise(HTTP::ConnectionError)
      expect { client.update_checklist_item(**update_args) }.to raise_error(Trello::ApiError)
    end
  end
end

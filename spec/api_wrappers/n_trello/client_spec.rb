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
end

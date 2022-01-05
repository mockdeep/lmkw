# frozen_string_literal: true

class Integration::Github < Integration
  CLIENT_ID = Rails.configuration.x.github.client_id
  CLIENT_SECRET = Rails.configuration.x.github.client_secret

  class << self
    def implementation=(implementation)
      @implementation = implementation
      @client = nil
    end

    def implementation
      @implementation ||= ::Octokit
    end

    def authorize_url(state:)
      client.authorize_url(CLIENT_ID, scope: "repo", state: state)
    end

    def client
      @client ||= implementation::Client.new(
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET,
      )
    end
  end

  validates :access_token, presence: true
  store_accessor :data, :access_token
  delegate :implementation, to: :class
  delegate :web_endpoint, to: :client

  def code=(code)
    data = client.exchange_code_for_token(code)
    self.access_token = data.access_token
  end

  def pull_requests
    client.issues.select(&:pull_request)
  end

  private

  def client
    @client ||= implementation::Client.new(
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      access_token: access_token,
    )
  end
end

# frozen_string_literal: true

require_relative "../modules"

class FakeApi::Github::Implementation
  class_attribute :endpoint_url

  def self.endpoint_url
    @endpoint_url || (raise ArgumentError, "missing endpoint_url")
  end

  class Issue
    attr_accessor :pull_request

    def initialize(pull_request:)
      self.pull_request = pull_request
    end
  end

  class TokenWrapper
    def access_token
      "some-auth-token"
    end
  end

  class Client
    attr_accessor :client_id, :client_secret, :access_token

    def initialize(client_id:, client_secret:, access_token: nil)
      self.client_id = client_id
      self.client_secret = client_secret
      self.access_token = access_token
    end

    def authorize_url(_client_id, state:, **)
      "/github/sessions/new?state=#{state}"
    end

    def implementation
      FakeApi::Github::Implementation
    end

    def exchange_code_for_token(_code)
      TokenWrapper.new
    end

    def issues
      [
        Issue.new(pull_request: true),
        Issue.new(pull_request: true),
        Issue.new(pull_request: false),
      ]
    end

    def web_endpoint
      "/github"
    end
  end
end

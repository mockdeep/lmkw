# frozen_string_literal: true

module FakeApi
  module Github
    class Implementation
      class << self
        attr_writer :endpoint_url

        def endpoint_url
          @endpoint_url || (raise ArgumentError, "missing endpoint_url")
        end
      end

      class Issue
        attr_accessor :pull_request

        def initialize(pull_request:)
          self.pull_request = pull_request
        end
      end

      class Client
        def initialize(client_id:, client_secret:, access_token: nil); end

        # https://github.com/login/oauth/authorize?client_id=b196fb782d84648a9ff2&scope=repo
        def authorize_url(_client_id, state:, **)
          "#{Implementation.endpoint_url}/login/oauth/authorize?state=#{state}"
        end

        def exchange_code_for_token(_code)
          OpenStruct.new(access_token: "some-auth-token")
        end

        def issues
          [
            Issue.new(pull_request: true),
            Issue.new(pull_request: true),
            Issue.new(pull_request: false),
          ]
        end

        def api_endpoint
          "/fake_github_url"
        end
      end
    end
  end
end

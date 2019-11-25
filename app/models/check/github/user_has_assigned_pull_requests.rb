# frozen_string_literal: true

class Check < ApplicationRecord
  module Github
    class UserHasAssignedPullRequests < Check
      delegate :pull_requests, to: :integration

      STEPS = ["name"].freeze

      def next_step
        STEPS.find { |step| public_send(step).nil? }
      end

      def message
        "#{pull_requests.count} assigned pull requests"
      end

      def url
        "#{integration.api_endpoint}pulls/assigned"
      end
    end
  end
end

# frozen_string_literal: true

class Check < ApplicationRecord
  module Github
    class UserHasAssignedPullRequests < Check
      delegate :pull_requests, to: :integration

      STEPS = ["name"].freeze

      def service
        "GitHub"
      end

      def next_count
        pull_requests.count
      end

      def next_step
        STEPS.find { |step| public_send(step).nil? }
      end

      def url
        "#{integration.web_endpoint}pulls/assigned"
      end
    end
  end
end

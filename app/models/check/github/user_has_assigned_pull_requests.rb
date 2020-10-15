# frozen_string_literal: true

class Check < ApplicationRecord
  module Github
    class UserHasAssignedPullRequests < Check
      delegate :pull_requests, to: :integration

      STEPS = ["name"].freeze

      def service
        "github"
      end

      def refresh
        counts.create!(value: pull_requests.count)
      end

      def next_step
        STEPS.find { |step| public_send(step).nil? }
      end

      def message
        "#{last_value} assigned pull requests"
      end

      def url
        "#{integration.web_endpoint}pulls/assigned"
      end
    end
  end
end

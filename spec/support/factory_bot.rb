# frozen_string_literal: true

module FactoryCache
  def self.user
    @user ||= FactoryBot.create(:user)
  end

  def self.test_integration
    @test_integration ||= FactoryBot.create(:integration)
  end

  def self.reset
    @user = nil
    @test_integration = nil
  end
end

RSpec.configure do |config|
  config.include(FactoryBot::Syntax::Methods)

  config.after do
    FactoryBot.rewind_sequences
    FactoryCache.reset
  end
end

module FactoryBot
  module Syntax
    module Methods
      def default_user
        FactoryCache.user
      end

      def default_integration
        FactoryCache.test_integration
      end
    end
  end
end

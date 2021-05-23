# frozen_string_literal: true

module FactoryCache
  def self.user
    @user ||= FactoryBot.create(:user)
  end

  def self.test_integration
    @test_integration ||= FactoryBot.create(:integration)
  end

  def self.manual_integration
    @manual_integration ||= FactoryBot.create(:manual_integration)
  end

  def self.reset
    @user = nil
    @test_integration = nil
    @manual_integration = nil
  end
end

RSpec.configure do |config|
  config.include(FactoryBot::Syntax::Methods)

  config.after do
    FactoryBot.rewind_sequences
    FactoryCache.reset
  end
end

module FactoryBot::Syntax::Methods
  def default_user
    FactoryCache.user
  end

  def default_integration
    FactoryCache.test_integration
  end

  def default_manual_integration
    FactoryCache.manual_integration
  end
end

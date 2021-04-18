# frozen_string_literal: true

RSpec.configure do |config|
  config.include(FactoryBot::Syntax::Methods)

  config.after { FactoryBot.rewind_sequences }
end

# frozen_string_literal: true

module Matchers
end

Dir[File.join(__dir__, "./matchers/*.rb")].each { |path| require path }

module Matchers
  def have_check(expected_name)
    Matchers::HaveCheck.new(expected_name)
  end

  def have_active_check(expected_name)
    Matchers::HaveActiveCheck.new(expected_name)
  end

  def have_inactive_check(expected_name)
    Matchers::HaveInactiveCheck.new(expected_name)
  end

  def have_no_checks
    Matchers::HaveNoChecks.new
  end

  def have_no_active_checks
    Matchers::HaveNoActiveChecks.new
  end

  def have_no_inactive_checks
    Matchers::HaveNoInactiveChecks.new
  end

  def have_error(expected_message)
    Matchers::HaveError.new(expected_message)
  end

  def have_flash(expected_type, expected_message)
    Matchers::HaveFlash.new(expected_type, expected_message)
  end

  def have_heading(text)
    Matchers::HaveHeading.new(text)
  end

  def change_record(record, attribute)
    Matchers::ChangeRecord.new(record, attribute)
  end

  def delete_record(record)
    Matchers::DeleteRecord.new(record)
  end

  def invoke(expected_method)
    Matchers::Invoke.new(expected_method)
  end
end

RSpec.configure { |config| config.include(Matchers) }

RSpec::Matchers.define_negated_matcher(:not_change, :change)
RSpec::Matchers.define_negated_matcher(:not_change_record, :change_record)
RSpec::Matchers.define_negated_matcher(:not_delete_record, :delete_record)

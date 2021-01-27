# frozen_string_literal: true

Dir[File.join(__dir__, "./matchers/*.rb")].sort.each { |path| require path }

def have_check(expected_name, text:)
  Matchers::HaveCheck.new(expected_name, text: text)
end

def have_no_checks
  Matchers::HaveNoChecks.new
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

RSpec::Matchers.define_negated_matcher(:not_change, :change)
RSpec::Matchers.define_negated_matcher(:not_change_record, :change_record)
RSpec::Matchers.define_negated_matcher(:not_delete_record, :delete_record)

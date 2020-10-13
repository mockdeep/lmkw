# frozen_string_literal: true

namespace(:job) do
  desc("run the given background job")
  task(:enqueue, [:callable_name] => :environment) do |_task, args|
    CallableJob.perform_later(args.fetch(:callable_name))
  end
end

# frozen_string_literal: true

group :everything, halt_on_fail: true do
  rspec_options = {
    all_after_pass: false,
    all_on_start: false,
    failed_mode: :keep,
    cmd: "bundle exec spring rspec",
  }

  guard :rspec, rspec_options do
    require "guard/rspec/dsl"
    dsl = Guard::RSpec::Dsl.new(self)

    rspec = dsl.rspec
    watch(rspec.spec_files)

    ruby = dsl.ruby
    dsl.watch_spec_files_for(ruby.lib_files)

    rails = dsl.rails(view_extensions: ["haml"])
    dsl.watch_spec_files_for(rails.app_files)
    dsl.watch_spec_files_for(rails.views)

    watch(rails.controllers) do |m|
      [
        rspec.spec.call("controllers/#{m[1]}_controller"),
      ]
    end

    watch(rails.app_controller) { "#{rspec.spec_dir}/controllers" }
  end

  guard :haml_lint, all_on_start: false do
    watch(/.+\.html.*\.haml$/)
    watch(%r{(?:.+/)?\.haml-lint\.yml$}) { |m| File.dirname(m[0]) }
  end

  guard :rubocop, all_on_start: false, cli: ["-A", "--display-cop-names"] do
    watch(/.+\.rb$/)
    watch(%r{bin/*})
    watch(/Guardfile/)
    watch(/Rakefile/)
    watch(/.+\.rake$/)
    watch(/.+\.ru$/)
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end
end

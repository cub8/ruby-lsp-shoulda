# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'minitest/test_task'

Minitest::TestTask.create do |t|
  # test/fixtures holds verbatim copies of another project's test files. They are
  # parser input for the discovery tests, not tests to run.
  t.test_globs = Dir['test/**/{test_*,*_test}.rb'].reject { |path| path.start_with?('test/fixtures/') }
end

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: %i[test rubocop]

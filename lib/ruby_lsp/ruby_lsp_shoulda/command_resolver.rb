# typed: true
# frozen_string_literal: true

require 'shellwords'

module RubyLsp
  module Shoulda
    class CommandResolver
      REPORTER_PATH = Listeners::TestStyle::MINITEST_REPORTER_PATH #: String
      RUNNER = "bundle exec ruby -r#{REPORTER_PATH}".freeze #: String
      RAILS_COMMAND = "#{RUNNER} bin/rails test".freeze #: String
      LOAD_PATH_FLAG = '-Itest'
      FRAMEWORK_TAG = 'framework:shoulda'
      CONSTANT_SEGMENT = /\A[A-Z]\w*\z/

      #: (GlobalState) -> void
      def initialize(global_state)
        @global_state = global_state
        @rails = File.exist?(File.join(global_state.workspace_path, 'bin', 'rails')) #: bool
      end

      #: (Array[Hash[Symbol, untyped]]) -> Array[String]
      def call(items)
        commands = []
        queue = items.dup

        until queue.empty?
          item = queue.shift #: as !nil
          tags = Set.new(item[:tags])
          next unless tags.include?(FRAMEWORK_TAG)

          path = URI(item[:uri]).full_path
          next unless path

          children = item[:children] || []

          if tags.include?('test_dir')
            commands << directory_command(path) if children.empty?
            queue.concat(children)
          elsif tags.include?('test_file')
            commands << file_command(path) if children.empty?
            queue.concat(children)
          else
            commands << "#{file_command(path)} --name #{Shellwords.escape(filter_for(item[:id]))}"
          end
        end

        commands
      end

      private

      #: (String) -> String
      def file_command(path)
        if rails?
          "#{RAILS_COMMAND} #{Shellwords.escape(path)}"
        else
          "#{RUNNER} #{LOAD_PATH_FLAG} #{Shellwords.escape(path)}"
        end
      end

      #: (String) -> String
      def directory_command(path)
        return "#{RAILS_COMMAND} #{Shellwords.escape(path)}" if rails?

        files = Dir.glob(
          "#{path}/**/{*_test,test_*}.rb",
          File::Constants::FNM_EXTGLOB | File::Constants::FNM_PATHNAME,
        ).map! { |file| Shellwords.escape(file) }

        "#{RUNNER} #{LOAD_PATH_FLAG} -e #{Shellwords.escape('ARGV.each { |f| require f }')} #{files.join(' ')}"
      end

      #: -> bool
      def rails?
        @rails
      end

      #: (String) -> String
      def filter_for(id)
        segments = id.split('#', 2)
        class_name = segments.first #: as !nil
        method_name = segments[1]

        return example_filter(class_name, method_name) if method_name

        class_name, context_name = split_context(class_name)

        if context_name
          context_filter(class_name, context_name)
        else
          group_filter(class_name)
        end
      end

      #: (String) -> String
      def group_filter(class_name)
        "/^#{Regexp.escape(class_name)}(#|::)/"
      end

      #: (String, String) -> String
      def context_filter(class_name, context_name)
        "/^#{Regexp.escape(class_name)}\\##{Regexp.escape("test_: #{context_name} should ")}/"
      end

      # A single example. The method name already carries shoulda's trailing ". ", so we
      # escape it whole and anchor both ends rather than rebuilding it from parts.
      #: (String, String) -> String
      def example_filter(class_name, method_name)
        "/^#{Regexp.escape(class_name)}\\##{Regexp.escape(method_name)}\\z/"
      end

      #: (String) -> [String, String?]
      def split_context(id)
        segments = id.split('::')
        boundary = segments.index { |segment| !segment.match?(CONSTANT_SEGMENT) }
        return [id, nil] unless boundary

        constants = segments[0...boundary] #: as !nil
        context = segments[boundary..] #: as !nil

        [constants.join('::'), context.join(' ')]
      end
    end
  end
end

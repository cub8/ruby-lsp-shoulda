# typed: strong
# frozen_string_literal: true

require 'ruby_lsp/addon'

require_relative '../../ruby_lsp_shoulda/version'
require_relative 'command_resolver'
require_relative 'test_discovery'

module RubyLsp
  module Shoulda
    class Addon < ::RubyLsp::Addon
      #: -> void
      def initialize
        super

        @global_state = nil #: GlobalState?
        @outgoing_queue = nil #: Thread::Queue?
      end

      # @override
      #: (GlobalState, Thread::Queue) -> void
      def activate(global_state, outgoing_queue)
        @global_state = global_state
        @outgoing_queue = outgoing_queue

        @outgoing_queue << Notification.window_log_message("Activating Ruby LSP Shoulda add-on v#{VERSION}")
      end

      # @override
      #: -> void
      def deactivate; end

      # @override
      #: (ResponseBuilders::TestCollection, Prism::Dispatcher, URI::Generic) -> void
      def create_discover_tests_listener(response_builder, dispatcher, uri)
        return unless @global_state

        TestDiscovery.new(
          response_builder,
          dispatcher,
          uri,
          @global_state.workspace_path,
        )
      end

      # @override
      #: (Array[Hash[Symbol, untyped]]) -> Array[String]
      def resolve_test_commands(items)
        global_state = @global_state #: as !nil
        CommandResolver.new(global_state).call(items)
      end

      # @override
      #: -> String
      def name
        'Ruby LSP Shoulda'
      end

      # @override
      #: -> String
      def version
        VERSION
      end
    end
  end
end

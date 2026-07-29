# typed: strong
# frozen_string_literal: true

require 'ruby_lsp/addon'

require_relative '../../ruby_lsp_shoulda/version'

module RubyLsp
  module Shoulda
    class Addon < ::RubyLsp::Addon
      #: -> void
      def initialize
        super

        @index = nil #: RubyIndexer::Index?
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

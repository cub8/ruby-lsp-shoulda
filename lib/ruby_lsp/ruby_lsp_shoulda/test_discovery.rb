# typed: true
# frozen_string_literal: true

module RubyLsp
  module Shoulda
    class TestDiscovery
      include ::RubyLsp::Requests::Support::Common

      #: (ResponseBuilders::TestCollection, Prism::Dispatcher, URI::Generic, String) -> void
      def initialize(response_builder, dispatcher, uri, workspace_path)
        @response_builder = response_builder
        @dispatcher = dispatcher
        @uri = uri

        path = uri.to_standardized_path #: as !nil
        @path = path #: String
        @workspace_path = workspace_path #: String
        @group_stack = [] #: Array[::RubyLsp::Requests::Support::TestItem]

        dispatcher.register(
          self,
          :on_call_node_enter,
          :on_call_node_leave,
        )
      end
    end
  end
end

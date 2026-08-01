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
        return unless @path.end_with?('base_test.rb')

        @workspace_path = workspace_path #: String
        @group_stack = [] #: Array[::RubyLsp::Requests::Support::TestItem]

        build_stub_test_items

        # dispatcher.register(
        #   self,
        #   :on_call_node_enter,
        #   :on_call_node_leave,
        # )
      end

      private

      def build_stub_test_items
        base = add_group('BaseTest', 4, 0, 31, 3)

        add_example(base, 'test_: Base should check for chaos. ', 5, 2, 7, 5)

        add_context(base, 'check maths', 12, 2, 20, 5)
        add_example(base, 'test_: check maths should check if 2+2 is 4. ', 13, 4, 15, 7)
        add_example(base, 'test_: check maths should check if 3*3 is 9. ', 17, 4, 19, 7)

        add_context(base, 'with setup', 22, 2, 30, 5)
        add_example(base, 'test_: with setup should see the setup value. ', 27, 4, 29, 7)
      end

      #: (String, Integer, Integer, Integer, Integer) -> ::RubyLsp::Requests::Support::TestItem
      def add_group(class_name, start_line, start_character, end_line, end_character)
        item = build_item(
          class_name,
          class_name,
          range(start_line, start_character, end_line, end_character),
        )
        @response_builder.add(item)
        @response_builder.add_code_lens(item)
        item
      end

      #: (::RubyLsp::Requests::Support::TestItem, String, Integer, Integer, Integer, Integer) -> void
      def add_context(group, context_name, start_line, start_character, end_line, end_character)
        item = build_item(
          "#{group.id}::#{context_name}",
          context_name,
          range(start_line, start_character, end_line, end_character),
        )
        group.add(item)
        @response_builder.add_code_lens(item)
      end

      #: (::RubyLsp::Requests::Support::TestItem, String, Integer, Integer, Integer, Integer) -> void
      def add_example(group, method_name, start_line, start_character, end_line, end_character)
        item = build_item(
          "#{group.id}##{method_name}",
          method_name,
          range(start_line, start_character, end_line, end_character),
        )
        group.add(item)
        @response_builder.add_code_lens(item)
      end

      #: (String, String, Interface::Range) -> ::RubyLsp::Requests::Support::TestItem
      def build_item(id, label, range)
        ::RubyLsp::Requests::Support::TestItem.new(id, label, @uri, range, framework: :shoulda)
      end

      #: (Integer, Integer, Integer, Integer) -> Interface::Range
      def range(start_line, start_character, end_line, end_character)
        Interface::Range.new(
          start: Interface::Position.new(line: start_line, character: start_character),
          end:   Interface::Position.new(line: end_line, character: end_character),
        )
      end
    end
  end
end

# typed: true
# frozen_string_literal: true

module RubyLsp
  module Shoulda
    class CommandResolver
      #: (GlobalState) -> void
      def initialize(global_state)
        @global_state = global_state
      end

      #: (Array[Hash[Symbol, untyped]]) -> Array[String]
      def call(items)

      end
    end
  end
end

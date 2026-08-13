# typed: true
# frozen_string_literal: true

module RubyLsp
  module Shoulda
    module IdBuilder
      CONTEXT_SEPARATOR = '::ctx:'

      class << self
        #: (class_fqn: String, method_name: String) -> String
        def example(class_fqn:, method_name:)
          "#{class_fqn}##{method_name}"
        end

        #: (class_fqn: String, contexts: Array[String]) -> String
        def context(class_fqn:, contexts:)
          separated_contexts = contexts.join(CONTEXT_SEPARATOR)

          "#{class_fqn}#{CONTEXT_SEPARATOR}#{separated_contexts}"
        end

        #: (String) -> [String, Array[String]]
        def split_context(id)
          class_name, *contexts = id.split(CONTEXT_SEPARATOR)
          raise ArgumentError if class_name.nil?

          [class_name, contexts]
        end
      end
    end
  end
end

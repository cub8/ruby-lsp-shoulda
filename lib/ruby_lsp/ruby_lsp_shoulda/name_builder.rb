# typed: true
# frozen_string_literal: true

module RubyLsp
  module Shoulda
    module NameBuilder
      PREFIX = 'test_: '

      class << self
        #: (
        #|  class_fqn: String,
        #|  should_name: String,
        #|  ?contexts: Array[String]
        #| ) -> String
        def call(class_fqn:, should_name:, contexts: [])
          subject = if contexts.empty?
                      class_fqn.delete_suffix('Test')
                    else
                      contexts.join(' ')
                    end

          "#{PREFIX}#{subject} should #{should_name}. "
        end

        #: (contexts: Array[String]) -> String
        def context_prefix(contexts:)
          raise ArgumentError, 'contexts cannot be empty' if contexts.empty?

          "#{PREFIX}#{contexts.join(' ')} "
        end
      end
    end
  end
end

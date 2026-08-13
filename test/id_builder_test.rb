# typed: true
# frozen_string_literal: true

require 'test_helper'
require 'ruby_lsp/ruby_lsp_shoulda/id_builder'

class IdBuilderTest < Minitest::Test
  IdBuilder = RubyLsp::Shoulda::IdBuilder

  def test_example_id
    id = IdBuilder.example(class_fqn: 'BaseTest', method_name: 'test_: Base should check for chaos. ')

    assert_equal 'BaseTest#test_: Base should check for chaos. ', id
  end

  def test_example_id_inside_namespace
    id = IdBuilder.example(class_fqn: 'Admin::NamespaceTest', method_name: 'test_something')

    assert_equal 'Admin::NamespaceTest#test_something', id
  end

  def test_context_id
    id = IdBuilder.context(class_fqn: 'BaseTest', contexts: ['check maths'])

    assert_equal 'BaseTest::ctx:check maths', id
  end

  def test_nested_context_id
    id = IdBuilder.context(class_fqn: 'NestedContextTest', contexts: ['check maths', 'check multiplying'])

    assert_equal 'NestedContextTest::ctx:check maths::ctx:check multiplying', id
  end

  def test_single_context_round_trip
    class_fqn = 'BaseTest'
    contexts = ['check maths']

    id = IdBuilder.context(class_fqn: class_fqn, contexts: contexts)

    assert_equal [class_fqn, contexts], IdBuilder.split_context(id)
  end

  def test_namespaced_class_round_trip
    class_fqn = 'Admin::NamespaceTest'
    contexts = ['check maths']

    id = IdBuilder.context(class_fqn: class_fqn, contexts: contexts)

    assert_equal [class_fqn, contexts], IdBuilder.split_context(id)
  end

  def test_multi_context_round_trip
    class_fqn = 'NestedContextTest'
    contexts = ['check maths', 'check multiplying', 'check by zero']

    id = IdBuilder.context(class_fqn: class_fqn, contexts: contexts)

    assert_equal [class_fqn, contexts], IdBuilder.split_context(id)
  end

  def test_special_characters_round_trip
    class_fqn = 'SpecialCharactersTest'
    contexts = ['hello! HELLO!!! [!@#$%^&*(){}<>???/\:;"|>-_+=\'`~]', 'with # and : inside']

    id = IdBuilder.context(class_fqn: class_fqn, contexts: contexts)

    assert_equal [class_fqn, contexts], IdBuilder.split_context(id)
  end

  def test_split_context_without_contexts
    assert_equal ['BaseTest', []], IdBuilder.split_context('BaseTest')
  end

  def test_split_context_raises_on_empty_id
    assert_raises ArgumentError do
      IdBuilder.split_context('')
    end
  end
end

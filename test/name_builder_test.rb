# typed: true
# frozen_string_literal: true

require 'test_helper'

class NameBuilderTest < Minitest::Test
  NameBuilder = RubyLsp::Shoulda::NameBuilder

  def test_call_starts_with_context_prefix
    contexts = ['check maths', 'check multiplying']
    name = NameBuilder.call(
      class_fqn:   'NestedContextTest',
      should_name: 'x',
      contexts:    contexts,
    )
    assert name.start_with?(NameBuilder.context_prefix(contexts: contexts))
  end

  def test_context_prefix
    contexts = ['check maths']
    prefix = NameBuilder.context_prefix(contexts: contexts)
    assert_equal 'test_: check maths ', prefix
  end

  def test_nested_context_prefix
    contexts = ['check maths', 'check multiplying']
    prefix = NameBuilder.context_prefix(contexts: contexts)
    assert_equal 'test_: check maths check multiplying ', prefix
  end

  def test_context_prefix_raises_an_error_if_empty_prefix
    assert_raises ArgumentError do
      NameBuilder.context_prefix(contexts: [])
    end
  end

  def test_name_for_should_in_nested_test_class
    name = NameBuilder.call(
      class_fqn:   'AnotherBaseTest::BasicTest',
      should_name: 'check for chaos',
      contexts:    [],
    )

    assert_equal 'test_: AnotherBaseTest::Basic should check for chaos. ',
                 name
  end

  def test_name_for_should_in_normal_test_class
    name = NameBuilder.call(
      class_fqn:   'BaseTest',
      should_name: 'check for chaos',
      contexts:    [],
    )

    assert_equal 'test_: Base should check for chaos. ', name
  end

  def test_name_for_should_inside_context
    name = NameBuilder.call(
      class_fqn:   'BaseTest',
      should_name: 'check if 2+2 is 4',
      contexts:    ['check maths'],
    )

    assert_equal 'test_: check maths should check if 2+2 is 4. ', name
  end

  def test_name_for_should_inside_nested_context
    name = NameBuilder.call(
      class_fqn:   'NestedContextTest',
      should_name: 'check if 3*3 is 9',
      contexts:    ['check maths', 'check multiplying'],
    )

    assert_equal 'test_: check maths check multiplying should check if 3*3 is 9. ', name
  end

  def test_inside_namespace
    name = NameBuilder.call(
      class_fqn:   'Admin::NamespaceTest',
      should_name: 'test inside namespace',
    )

    assert_equal 'test_: Admin::Namespace should test inside namespace. ', name
  end

  def test_not_a_test_class
    name = NameBuilder.call(
      class_fqn:   'NotATestClass',
      should_name: 'check for chaos',
    )
    assert_equal 'test_: NotATestClass should check for chaos. ', name
  end

  def test_special_characters
    name = NameBuilder.call(
      class_fqn:   'SpecialCharactersTest',
      should_name: 'hello! HELLO!!! [!@#$%^&*(){}<>???/\:;"|>-_+=\'`~]',
    )

    assert_equal 'test_: SpecialCharacters should hello! HELLO!!! [!@#$%^&*(){}<>???/\:;"|>-_+=\'`~]. ',
                 name
  end
end

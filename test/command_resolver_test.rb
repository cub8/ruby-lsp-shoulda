# typed: true
# frozen_string_literal: true

require 'test_helper'

class CommandResolverTest < Minitest::Test
  TEST_FILE_PATH = '/workspace/test/integration/base_test.rb'
  ESCAPED_PATH = Regexp.escape(TEST_FILE_PATH)

  def test_filters_non_shoulda_items
    rails_item = item(
      id:   'rails-item',
      tags: ['debug', 'framework:rails'],
    )
    rspec_item = item(
      id:   'rspec-item',
      tags: ['debug', 'framework:rspec'],
    )
    shoulda_item = example('BaseTest#test_: Base should check for chaos. ')

    items = [rails_item, rspec_item, shoulda_item]
    resolver = RubyLsp::Shoulda::CommandResolver.new(rails: true)
    commands = resolver.call(items)
    assert_equal 1, commands.count
    assert_filter_matches(commands.first, 'BaseTest', 'test_: Base should check for chaos. ')
  end

  def test_generates_valid_command_based_on_rails_presence
    shoulda_item = example('BaseTest#test_: Base should check for chaos. ')
    items = [shoulda_item]
    rails_resolver = RubyLsp::Shoulda::CommandResolver.new(rails: true)
    minitest_resolver = RubyLsp::Shoulda::CommandResolver.new(rails: false)

    rails_command = rails_resolver.call(items).first #: as !nil
    minitest_command = minitest_resolver.call(items).first #: as !nil

    rails_match = %r{bin/rails test #{ESCAPED_PATH}}
    minitest_match = /-Itest #{ESCAPED_PATH}/

    assert_match rails_match, rails_command
    refute_match minitest_match, rails_command
    refute_match rails_match, minitest_command
    assert_match minitest_match, minitest_command
  end

  private

  #: (String, String, String) -> void
  def assert_filter_matches(command, klass, method_name)
    filter = extract_name_regexp(command)
    assert_match Regexp.new(filter), "#{klass}##{method_name}"
  end

  #: (String) -> String
  def extract_name_regexp(command)
    words = Shellwords.split(command)

    index = words.index('--name')
    raise "no --name flag in: #{command}" unless index

    filter = words[index + 1] #: as !nil
    filter[%r{\A/(.*)/\z}m, 1] #: as !nil
  end

  #: (
  #|  id: String,
  #|  tags: Array[String],
  #|  ?children: Array[Hash[Symbol, untyped]],
  #|  ?path: String
  #| ) -> Hash[Symbol, untyped]
  def item(id:, tags:, children: [], path: TEST_FILE_PATH)
    {
      id:       id,
      label:    id,
      uri:      URI::Generic.from_path(path: path).to_s,
      range:    { start: { line: 0, character: 0 }, end: { line: 0, character: 3 } },
      children: children,
      tags:     Array(tags),
    }
  end

  #: (
  #|  String id,
  #|  ?children: Array[Hash[Symbol, untyped]],
  #|  ?path: String
  #| ) -> Hash[Symbol, untyped]
  def example(id, children: [], path: TEST_FILE_PATH)
    item(id: id, tags: ['debug', 'framework:shoulda'], children: children, path: path)
  end

  #: (
  #|  String id,
  #|  ?children: Array[Hash[Symbol, untyped]],
  #|  ?path: String
  #| ) -> Hash[Symbol, untyped]
  def group(id, children: [], path: TEST_FILE_PATH)
    item(id: id, tags: ['test_group', 'debug', 'framework:shoulda'], children: children, path: path)
  end

  #: (
  #|  ?children: Array[Hash[Symbol, untyped]],
  #|  ?path: String
  #| ) -> Hash[Symbol, untyped]
  def file_item(children: [], path: TEST_FILE_PATH)
    item(id: URI::Generic.from_path(path: path).to_s,
         tags: ['test_file', 'debug', 'framework:shoulda'],
         children: children, path: path,)
  end
end

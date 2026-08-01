# typed: true
# frozen_string_literal: true

require 'test_helper'

class TestDiscoveryTest < Minitest::Test
  def test_discovers_should_and_context
    source = <<~RUBY
      class RandomTest < ActiveSupport::TestCase
        should "returns your mother!" do; end

        context "check maths" do
          should "check if 2+2 is 4" do; end
        end
      end
    RUBY

    uri = URI("file://#{File.expand_path('test/fake_test.rb', Dir.pwd)}")

    with_server(source, uri) do |server, _uri|
      server.global_state.index.index_single(uri, <<~RUBY)
        module Minitest
          class Test; end
        end
        module ActiveSupport
          class TestCase < Minitest::Test; end
        end
      RUBY

      server.process_message(id: 1, method: 'rubyLsp/discoverTests', params: {
                               textDocument: { uri: uri },
                             },)

      items = pop_result(server).response
      assert_equal(['RandomTest'], items.map { |i| i[:label] })
    end
  end
end

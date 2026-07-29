# frozen_string_literal: true

require 'test_helper'

class Ruby::Lsp::TestShoulda < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RubyLsp::Shoulda::VERSION
  end
end

# typed: true
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'ruby-lsp-shoulda'

require 'minitest/autorun'
# `ruby_lsp/test_helper` has no requires of its own -- it assumes the server
# internals are already loaded. Without this, `RubyLsp::Server` is undefined.
require 'ruby_lsp/internal'
require 'ruby_lsp/test_helper'
require 'ruby_lsp/ruby_lsp_shoulda/addon'


class Minitest::Test
  include RubyLsp::TestHelper
end

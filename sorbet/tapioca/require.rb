# typed: true
# frozen_string_literal: true

# Add your extra requires here (`bin/tapioca require` can be used to bootstrap this list)

# `require "ruby-lsp"` only defines RubyLsp::VERSION -- the server internals are
# loaded by the launcher, not by the gem entrypoint. Require them explicitly so
# tapioca can see RubyLsp::Addon and friends.
require 'ruby_lsp/internal'
# Same story for the test helper: it is an opt-in file that only test suites
# require, so tapioca never sees RubyLsp::TestHelper without this.
require 'ruby_lsp/test_helper'

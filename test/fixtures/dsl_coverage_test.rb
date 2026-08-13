# Constant needed so that `described_type` in WidgetTest has something to find.
class Widget; end

class DslCoverageTest < ActiveSupport::TestCase
  class PassingMatcher
    attr_reader :description

    def initialize(description)
      @description = description
    end

    def matches?(_target) = true
    def failure_message = 'expected to match'
    def failure_message_when_negated = 'expected not to match'
  end

  class FailingMatcher
    attr_reader :description

    def initialize(description)
      @description = description
    end

    def matches?(_target) = false
    def failure_message = 'expected to match'
    def failure_message_when_negated = 'expected not to match'
  end

  subject { Object.new }

  # ITEM — this line is DELIBERATELY placed after the nested classes above.
  # If the gem tracks "am I inside a test class" as a boolean instead of a stack,
  # leaving PassingMatcher/FailingMatcher will clear the flag and this should will vanish.
  should 'still be discovered after nested non-test classes' do
    assert true
  end

  # ITEM — the :before option has no effect on the method name.
  should 'accept a before option', before: -> { @before_ran = true } do
    assert @before_ran
  end

  # ITEM — before_should creates a regular test with a predictable name.
  # Easy to miss, because the method name does not start with "should".
  before_should 'be a before_should at class level' do
    assert true
  end

  # NO ITEM (b) — the name comes from matcher.description, computed at runtime.
  should PassingMatcher.new('be a matcher based should')

  # NO ITEM (b) — the name is "not #{matcher.description}", also runtime.
  # should_not has NO string variant — `should_not "text"` raises NoMethodError.
  should_not FailingMatcher.new('be a negated matcher')

  # NO ITEM (a) — a should without a block goes into should_eventuallys.
  # At runtime it prints "  * DEFERRED: …" on stdout and creates no method.
  should 'be deferred without a block'

  # NO ITEM (a) — should_eventually never creates a method, with or without a block.
  should_eventually 'be deferred explicitly'

  should_eventually 'be deferred with a block' do
    flunk 'this never runs'
  end

  # NO ITEM (a) — a context without a block prints a WARNING and creates an empty context.
  context 'no block here'

  # NO ITEM — an empty context with a block. Zero shoulds inside, so the context
  # leaf would be runnable via a regexp that matches nothing.
  # Design note: you only find this out in on_call_node_leave.
  context 'empty context with a block' do
    # deliberately empty
  end

  context 'inside a context' do
    # NO ITEM — setup/teardown/subject are not tests.
    setup { @log = [:context_setup] }
    teardown { @log = nil }
    subject { @log }

    # ITEM — before_should inside a context goes through
    # Context#method_missing → ClassMethods#before_should → current_context.should.
    # The proc runs BEFORE the current context's setup, so @log is still nil here.
    before_should 'run before the context setup' do
      assert_nil @log, "the :before proc runs before the context's own setup"
    end

    # NO ITEM (a)
    should_eventually 'be deferred inside a context'
  end

  # Demonstration of where :before sits in the execution order:
  #   parent setups → :before → current context's setup → test body
  context 'outer' do
    setup { @log = [:outer_setup] }

    context 'inner' do
      setup { @log << :inner_setup }

      # ITEM
      should 'run the before proc between parent and current setup',
             before: -> { @log << :before_proc } do
        assert_equal %i[outer_setup before_proc inner_setup], @log
      end
    end
  end
end

class WidgetTest < ActiveSupport::TestCase
  # ITEM — a plain should. `described_type` on its own is NO ITEM: a class-level
  # helper returning a constant derived from the class name (WidgetTest → Widget).
  should 'expose described_type' do
    assert_equal Widget, self.class.described_type
  end
end

# ---------------------------------------------------------------------------
# Expected runnable_methods (for the golden file):
#
# DslCoverageTest:
#   "test_: DslCoverage should still be discovered after nested non-test classes. "   ITEM
#   "test_: DslCoverage should accept a before option. "                              ITEM
#   "test_: DslCoverage should be a before_should at class level. "                   ITEM
#   "test_: DslCoverage should be a matcher based should. "                           NO ITEM (b)
#   "test_: DslCoverage should not be a negated matcher. "                            NO ITEM (b)
#   "test_: inside a context should run before the context setup. "                   ITEM
#   "test_: outer inner should run the before proc between parent and current setup. " ITEM
#
# WidgetTest:
#   "test_: Widget should expose described_type. "                                    ITEM
#
# Lines marked NO ITEM (a) are not on this list at all — they create no methods.
# Lines marked NO ITEM (b) ARE on the list, but the gem will not generate them.
# That is a documented limitation, not a bug — record it in the YAML with an annotation.
# ---------------------------------------------------------------------------

class FakeShoulda
  def context(_name)
    yield if block_given?
  end

  def should(_name)
    yield if block_given?
  end
end

class ReceiverGuardTest < ActiveSupport::TestCase
  FakeShoulda.new.context('not a real context') {}

  should 'the only real test' do
    assert_instance_of String, 'I am real!'
  end
end

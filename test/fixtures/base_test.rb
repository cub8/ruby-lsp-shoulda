class BaseTest < ActiveSupport::TestCase
  should 'check for chaos' do
    assert_equal 'Chaos!', 'CHAOS!'.titleize
  end

  should 'miss this test'
  context 'miss this context'

  context 'check maths' do
    should 'check if 2+2 is 4' do
      assert_equal 4, 2 + 2
    end

    should 'check if 3*3 is 9' do
      assert_equal 9, 3 * 3
    end
  end

  context 'with setup' do
    setup { @value = 42 }
    teardown { @value = nil }
    subject { @value }

    should 'see the setup value' do
      assert_equal 42, @value
    end
  end
end

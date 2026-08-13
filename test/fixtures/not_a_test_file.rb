class NotATestFileTest < ActiveSupport::TestCase
  should 'check for chaos' do
    assert_equal 'Chaos!', 'CHAOS!'.titleize
  end

  context 'check maths' do
    should 'check if 2+2 is 4' do
      assert_equal 4, 2 + 2
    end

    should 'check if 3*3 is 9' do
      assert_equal 9, 3 * 3
    end
  end
end

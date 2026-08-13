class NestedContextTest < ActiveSupport::TestCase
  context 'check maths' do
    context 'check sum' do
      should 'check if 2+2 is 4' do
        assert_equal 4, 2 + 2
      end

      should 'check if 2+2+8 is 12' do
        assert_equal 12, 2 + 2 + 8
      end
    end

    context 'check multiplying' do
      should 'check if 3*3 is 9' do
        assert_equal 9, 3 * 3
      end

      should 'check if 3*3*3 is 27' do
        assert_equal 27, 3 * 3 * 3
      end
    end
  end
end

class AnotherBaseTest < ActiveSupport::TestCase
  class BasicTest < ActiveSupport::TestCase
    should 'check for chaos' do
      assert_equal 'Chaos!', 'CHAOS!'.titleize
    end

    test 'normal Rails test' do
      assert_equal 'Rails', 'Rails'
    end

    def test_driven_by_method
      assert_equal 26, 'This method is test driven'.length
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
end

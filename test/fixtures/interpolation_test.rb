class InterpolationTest < ActiveSupport::TestCase
  TEST_NAME = 'HELLO!!'

  should "check for #{TEST_NAME}" do
    assert_not_equal 'High', 'Hello'
  end

  %i[hi hello guten_morgen].each do |greeting|
    should "greet with #{greeting}" do
      assert_instance_of Symbol, greeting
    end
  end
end

class MixedClassTest < ActiveSupport::TestCase
  test 'normal Rails test' do
    assert_equal 'Rails', 'Rails'
  end

  def test_driven_by_method
    assert_equal 26, 'This method is test driven'.length
  end

  should 'check for length' do
    assert_equal 6, 'abcdef'.length
  end

  # Fun-fact: zwykłe testy Rails/Minitest wewnątrz `context` nie działają:
  #   test "x" do ... end   → ArgumentError, bo trafia w prywatne Kernel#test,
  #                           a nie w method_missing → ActiveSupport::Testing::Declarative
  #   def test_x; end       → cicho definiuje metodę singletonową na obiekcie Context
  #                           (blok jest instance_execowany), więc nigdy nie jest testem
  context 'we are going inside the context' do
    should 'check this number' do
      assert_equal 6, 42 / 7
    end
  end
end

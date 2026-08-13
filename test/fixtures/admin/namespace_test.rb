module Admin
  class NamespaceTest < ActiveSupport::TestCase
    should 'test inside namespace' do
      assert_nothing_raised do
        'Hello!'
      end
    end

    context 'test inside namespace' do
      should 'Big shot' do
        assert_includes "Now's your time to be [BIG SHOT]", 'BIG SHOT'
      end
    end
  end
end

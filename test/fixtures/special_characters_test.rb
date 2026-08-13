class SpecialCharactersTest < ActiveSupport::TestCase
  should 'hello! HELLO!!! [!@#$%^&*(){}<>???/\:;"|>-_+=\'`~]' do
    assert_equal '!!!', '!!!'
  end
end

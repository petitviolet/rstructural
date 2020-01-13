require "test_helper"

class AdtTest < Minitest::Test
  module Option
    extend ADT
    None = const
    Some = data :value
  end

  def test_it_defines_adt
    assert_equal Option::None.name, 'AdtTest::Option::None'
    assert_equal Option::Some.name, 'AdtTest::Option::Some'
    assert_raises(NoMethodError) { Option::None.new }
    assert_raises(NoMethodError) { Option::None.value }

    some = Option::Some.new(100)
    assert_equal some.value, 100

    case some
    in Option::None
        assert false
    in Option::Some[value]
        assert_equal value, 100
    else
      assert false
    end
  end
end

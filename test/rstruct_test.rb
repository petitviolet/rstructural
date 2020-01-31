require "test_helper"

class StructTest < Minitest::Test
  Value = Struct.new(:value)

  def test_it_defines_struct
    assert_equal Value.name, 'StructTest::Value'
    value = Value.new(100)
    assert_equal value.value, 100
    assert_equal value[:value], value.value
    assert_equal value, Value.new(100)
    case value
    in Value[n]
        assert_equal n, 100
    else
      assert false
    end
  end
end

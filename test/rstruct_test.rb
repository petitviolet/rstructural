require "test_helper"

class StructTest < Minitest::Test
  Value = Rstructural::Struct.new(:value)

  def test_it_defines_struct
    assert_equal Value.to_s, '<StructTest::Value>'
    assert_equal Value.name, 'StructTest::Value'
    value = Value.new(100)
    assert value.is_a?(Value)
    assert !value.is_a?(Integer)
    assert_equal value.value, 100
    assert_equal value[:value], value.value
    assert_equal value, Value.new(100)
    assert_equal value.to_s, 'StructTest::Value(value: 100)'
    assert_equal Value.new(nil).to_s, 'StructTest::Value(value: nil)'
    case value
    in Value[n]
        assert_equal n, 100
    else
      assert false
    end
  end

  def test_it_copy
    value = Value.new(100)
    assert_equal value.copy(value: 200), Value.new(200)
    assert_equal value.copy(), value
  end
end

require "test_helper"

class StructTest < Minitest::Test
  Value = Rstructural::Struct.new(:value)
  Point = Rstructural::Struct.new(:x, :y)

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

  def test_deconstruct
    value = Value.new(100)
    assert_equal value.deconstruct, [100]
    case value
      in Value[i, j]
      assert false
      in Value[i]
      assert_equal i, 100
    else
      assert false
    end

    case value
      in [i, j]
      assert false
      in [i]
      assert_equal i, 100
    else
      assert false
    end
  end

  def test_deconstruct_keys
    point = Point.new(1, 2)
    assert_equal point.deconstruct_keys, {x: 1, y: 2}
    assert_equal point.deconstruct_keys([:a, :b]), {x: 1, y: 2}

    case point
      in {a:, x:, y:}
        assert false
      in {a:, b:, y:}
        assert false
      in {x:, y:}
        assert_equal x, 1
        assert_equal y, 2
    end
  end
end

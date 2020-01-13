require "test_helper"

class RstructTest < Minitest::Test
  Type = Rstruct.new(:value)

  def test_it_defines_struct
    assert_equal Type.name, 'RstructTest::Type'
    value = Type.new(100)
    assert_equal value.value, 100
    assert_equal value, Type.new(100)
    case value
    in Type[n]
        assert_equal n, 100
    else
      assert false
    end
  end
end

require "test_helper"

class EnumTest < Minitest::Test
  module Color
    extend Enum
    Red = enum 'red'
    Green = enum 'green' do
      def to_red
        Red
      end
    end
    Blue = enum 'blue'
  end

  def test_it_defines_adt
    assert_equal Color::Red.name, 'EnumTest::Color::Red'
    assert_equal Color::Red.value, 'red'
    assert_equal Color::Green.name, 'EnumTest::Color::Green'
    assert_equal Color::Green.to_red, Color::Red
    assert_raises(NoMethodError) { Color::Red.new }

    case Color.of('blue')
    in Color::Red
        assert false
    in Color::Green
        assert false
    in Color::Blue
        assert true
    else
      assert false
    end

    assert_nil Color.of('orange')
  end
end

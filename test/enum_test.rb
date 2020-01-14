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

    interface do
      def is_red?
        case self
        in Red
          true
        else
          false
        end
      end
    end
  end

  def test_it_defines_enum
    assert_equal Color::Red.name, 'EnumTest::Color::Red'
    assert_equal Color::Red.value, 'red'
    assert_equal Color::Green.name, 'EnumTest::Color::Green'
    assert_equal Color::Green.to_red, Color::Red
    assert_raises(NoMethodError) { Color::Red.new }

    assert_equal Color::Red.is_red?, true
    assert_equal Color::Blue.is_red?, false
    assert_equal Color::Green.to_red.is_red?, true

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

  module Status1
    extend Enum
    OK = enum true
    NG = enum false
  end
  module Status2
    extend Enum
    OK2 = enum true
    NG2 = enum false
  end

  def test_it_should_differenct_instances_with_the_same_value
    assert_equal(Status1.of(true), Status1::OK)
    assert_equal(Status1.of(true) == Status2::OK2, false)
  end
end

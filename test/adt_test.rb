require "test_helper"

class AdtTest < Minitest::Test
  module Option
    extend ADT
    None = const do
      def map(f)
        self
      end
    end
    Some = data :value do |mod|
      def map(f)
        Some.new(f.call(value))
      end
    end

    interface do
      def flat_map(&f)
        case self
        in None
          None
        in Some[value]
          f.call(value)
        end
      end
    end
  end

  def test_it_defines_adt
    assert_equal Option::None.name, 'AdtTest::Option::None'
    assert_equal Option::Some.name, 'AdtTest::Option::Some'
    assert_raises(NoMethodError) { Option::None.new }
    assert_raises(NoMethodError) { Option::None.value }

    some = Option::Some.new(100)
    assert_equal some.value, 100
    assert_equal some.map(proc { |i| i * 2 }), Option::Some.new(200)

    assert_equal some.flat_map { |v| Option::Some.new(v * 2) }, Option::Some.new(200)
    assert_equal Option::None.flat_map { |v| Option::Some.new(v * 2) }, Option::None

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

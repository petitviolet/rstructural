require "test_helper"

class AdtTest < Minitest::Test
  module Maybe
    extend ADT
    Nothing = const do
      def map(f)
        self
      end
    end
    Just = data :value do |mod|
      def map(f)
        Just.new(f.call(value))
      end
    end

    interface do
      def flat_map(&f)
        case self
        in Nothing
          Nothing
        in Just[value]
          f.call(value)
        end
      end
    end
  end

  def test_it_defines_adt
    assert_equal Maybe::Nothing.name, 'AdtTest::Maybe::Nothing'
    assert_equal Maybe::Just.name, 'AdtTest::Maybe::Just'
    assert_raises(NoMethodError) { Maybe::Nothing.new }
    assert_raises(NoMethodError) { Maybe::Nothing.value }

    some = Maybe::Just.new(100)
    assert_equal some.value, 100
    assert_equal some.map(proc { |i| i * 2 }), Maybe::Just.new(200)

    assert_equal some.flat_map { |v| Maybe::Just.new(v * 2) }, Maybe::Just.new(200)
    assert_equal Maybe::Nothing.flat_map { |v| Maybe::Just.new(v * 2) }, Maybe::Nothing

    case some
    in Maybe::Nothing
        assert false
    in Maybe::Just[value]
        assert_equal value, 100
    else
      assert false
    end
  end
end

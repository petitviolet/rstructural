require "test_helper"

class OptionTest < Minitest::Test
  def test_of_creates_instance
    assert_equal Option.of(100), Option::Some.new(100)
    assert_equal Option.of(nil), Option::None
  end

  def test_map
    assert_equal Option.of(100).map { |v| v * 2 }, Option::Some.new(200)
    assert_equal Option.of(100).map { |v| nil }, Option::None
    assert_equal Option.of(nil).map { |v| v * 2 }, Option::None
  end

  def test_flat_map
    assert_equal Option.of(100).flat_map { |v| Option.of(v * 2) }, Option::Some.new(200)
    assert_equal Option.of(100).flat_map { |v| Option.of(nil) }, Option::None
    assert_equal Option.of(nil).flat_map { |v| v * 2 }, Option::None
  end

  def test_get_or_else
    assert_equal Option.of(100).get_or_else(999), 100
    assert_equal Option.of(nil).get_or_else(999), 999
    assert_equal Option.of(nil).get_or_else { 999 }, 999
    assert_equal Option.of(nil).get_or_else(0) { 999 }, 999
  end

  def test_flatten
    assert_equal Option.of(100).flatten, Option::Some.new(100)
    assert_equal Option.of(nil).flatten, Option::None
    assert_equal Option.of(Option.of(Option.of(100))).flatten, Option::Some.new(100)
    assert_equal Option.of(Option.of(Option.of(nil))).flatten, Option::None
  end
end

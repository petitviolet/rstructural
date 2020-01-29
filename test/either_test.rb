require "test_helper"

class EitherTest < Minitest::Test
  def test_creates_instances
    assert_equal Either.right(100), Either::Right.new(100)
    assert_equal Either.right(nil), Either::Right.new(nil)
    assert_equal Either.left(100), Either::Left.new(100)
    assert_equal Either.left(nil), Either::Left.new(nil)
  end

  def test_try_creates_instances
    assert_equal Either.try { 100 }, Either::Right.new(100)
    assert_equal Either.try { nil }, Either::Right.new(nil)
    assert_equal Either.try { 100 }, Either::Right.new(100)
    left = Either.try { raise RuntimeError, "error" }
    assert_equal left.left?, true
    assert_equal left.value.message, "error"
  end

  def test_right?
    assert_equal Either.right(100).right?, true
    assert_equal Either.left(100).right?, false
  end

  def test_left?
    assert_equal Either.right(100).left?, false
    assert_equal Either.left(100).left?, true
  end

  def test_map
    assert_equal Either.right(100).map { |v| v * 2 }, Either::Right.new(200)
    assert_equal Either.right(100).map { |v| nil }, Either::Right.new(nil)
    assert_equal Either.left(100).map { |v| v * 2 }, Either::Left.new(100)
  end

  def test_map_left
    assert_equal Either.right(100).map_left { |v| v * 2 }, Either::Right.new(100)
    assert_equal Either.left(100).map_left { |v| v * 2 }, Either::Left.new(200)
    assert_equal Either.left(100).map_left { |v| nil }, Either::Left.new(nil)
  end

  def test_flat_map
    assert_equal Either.right(100).flat_map { |v| Either.right(v * 2) }, Either::Right.new(200)
    assert_equal Either.right(100).flat_map { |v| Either.left(v * 2) }, Either::Left.new(200)
    assert_equal Either.left(100).flat_map { |v| Either.right(v * 2) }, Either::Left.new(100)
    assert_equal Either.left(100).flat_map { |v| Either.left(v * 2) }, Either::Left.new(100)
  end

  def test_flat_map_left
    assert_equal Either.right(100).flat_map_left { |v| Either.right(v * 2) }, Either::Right.new(100)
    assert_equal Either.right(100).flat_map_left { |v| Either.left(v * 2) }, Either::Right.new(100)
    assert_equal Either.left(100).flat_map_left { |v| Either.right(v * 2) }, Either::Right.new(200)
    assert_equal Either.left(100).flat_map_left { |v| Either.left(v * 2) }, Either::Left.new(200)
  end

  def test_right_or_else
    assert_equal Either.right(100).right_or_else(999), 100
    assert_nil Either.right(nil).right_or_else(999)
    assert_equal Either.left(100).right_or_else(999), 999
    assert_equal Either.left(100).right_or_else { 999 }, 999
    assert_equal Either.left(nil).right_or_else(0) { 999 }, 999
  end

  def test_left_or_else
    assert_equal Either.left(100).left_or_else(999), 100
    assert_nil Either.left(nil).left_or_else(999)
    assert_equal Either.right(100).left_or_else(999), 999
    assert_equal Either.right(100).left_or_else { 999 }, 999
    assert_equal Either.right(nil).left_or_else(0) { 999 }, 999
  end
end

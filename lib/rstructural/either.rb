# frozen_string_literal: true
require_relative './adt'

module Rstructural::Either
  extend Rstructural::ADT

  Left = data :value
  Right = data :value

  def self.left(obj)
    Left.new(obj)
  end

  def self.right(obj)
    Right.new(obj)
  end

  def self.try(catch_nil: false, &block)
    result = block.call
    if catch_nil && result.nil?
      Left.new(nil)
    else
      Right.new(result)
    end
  rescue => e
    Left.new(e)
  end

  interface do
    def right?
      case self
      in Left
        false
      in Right
        true
      end
    end

    def left?
      !right?
    end

    def map(&f)
      case self
      in Left
        self
      in Right[value]
        Right.new(f.call(value))
      end
    end

    def map_left(&f)
      case self
      in Left[value]
        Left.new(f.call(value))
      in Right
        self
      end
    end

    def flat_map(&f)
      case self
      in Left
        self
      in Right[value]
        f.call(value)
      end
    end

    def flat_map_left(&f)
      case self
      in Left[value]
        f.call(value)
      in Right
        self
      end
    end

    def swap
      case self
      in Left[value]
        Right.new(value)
      in Right[value]
        Left.new(value)
      end
    end

    def right_or_else(default = nil)
      case self
      in Right[value]
        value
      in Left
        if block_given?
          yield
        else
          default
        end
      end
    end

    def left_or_else(default = nil)
      case self
      in Left[value]
        value
      in Right
        if block_given?
          yield
        else
          default
        end
      end
    end
  end
end

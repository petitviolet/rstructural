# frozen_string_literal: true
require_relative './adt'

module Rstructural::Option
  extend Rstructural::ADT

  Some = data :value
  None = const do
    def value
      nil
    end
  end

  def self.of(obj)
    obj.nil? ? None : Some.new(obj)
  end

  interface do
    def map(&f)
      case self
      in Some[value]
        Option.of(f.call(value))
      in None
        None
      end
    end

    def flat_map(&f)
      case self
      in Some[value]
        f.call(value)
      in None
        None
      end
    end

    def get_or_else(default = nil)
      case self
      in Some[value]
        value
      in None
        if block_given?
          yield
        else
          default
        end
      end
    end

    def flatten
      case self
      in Some[value] if value.is_a?(Option)
        value.flatten
      in Some[value]
        Option.of(value)
      in None
        None
      end
    end
  end
end

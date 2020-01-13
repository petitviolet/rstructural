# frozen_string_literal: true

require_relative '../rstruct'

module Enum
  def self.extended(mod)
    @@enum_values ||= []
  end

  def enum(value)
    if (type = of(value))
      raise ArgumentError, "Enum '#{value}' already defined in #{type.name}"
    end
    Rstruct.new(:value, __caller: caller).new(value).tap do |k|
      @@enum_values << k
      def k.name
        self.class.name
      end
    end
  end

  def of(value)
    @@enum_values.find { |v| v.value == value }
  end
end


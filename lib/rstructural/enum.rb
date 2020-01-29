# frozen_string_literal: true

require_relative './struct'

module Rstructural::Enum
  def self.extended(klass)
    klass.class_variable_set(:@@enum_values, [])
    klass.class_variable_set(:@@enum_super_class, klass)
  end

  def enum(value, &block)
    if (type = of(value))
      raise ArgumentError, "Enum '#{value}' already defined in #{type.name}"
    end
    Rstructural::Struct.new(:value, __caller: caller, &block).new(value).tap do |k|
      self.class_variable_get(:@@enum_values) << k
      k.class.include(self.class_variable_get(:@@enum_super_class))
      def k.name
        self.class.name
      end
    end
  end

  def of(value)
    self.class_variable_get(:@@enum_values).find { |v| v.value == value }
  end

  def interface(&block)
    self.class_variable_get(:@@enum_values).each do |t|
      t.class.class_eval(&block)
    end
  end
end


# frozen_string_literal: true

require_relative './struct'

module Rstructural::ADT
  def self.extended(klass)
    klass.class_variable_set(:@@adt_types, [])
  end

  def const(value = nil, &block)
    if value
      Rstructural::Struct.new(:value, __caller: caller, &block).new(value)
    else
      Rstructural::Struct.new(__caller: caller, &block).new
    end.tap do |k|
      self.class_variable_get(:@@adt_types) << k
      def k.name
        self.class.name
      end
    end
  end

  def data(*fields, &block)
    Rstructural::Struct.new(*fields, __caller: caller, &block).tap { |k| self.class_variable_get(:@@adt_types) << k }
  end

  def interface(&block)
    self.class_variable_get(:@@adt_types).each do |t|
      case t
      in Class
        t.class_eval(&block)
      else
        t.class.class_eval(&block)
      end
    end
  end
end

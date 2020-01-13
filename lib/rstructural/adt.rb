# frozen_string_literal: true

require_relative './struct'

module Rstructural::ADT
  def self.extended(klass)
    @@adt_types ||= []
  end

  def const(value = nil, &block)
    if value
      Rstructural::Struct.new(:value, __caller: caller, &block).new(value)
    else
      Rstructural::Struct.new(__caller: caller, &block).new
    end.tap do |k|
      @@adt_types << k
      def k.name
        self.class.name
      end
    end
  end

  def data(*fields, &block)
    Rstructural::Struct.new(*fields, __caller: caller, &block).tap { |k| @@adt_types << k.name }
  end
end

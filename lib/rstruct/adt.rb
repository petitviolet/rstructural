# frozen_string_literal: true

require_relative '../rstruct'

module ADT
  def self.extended(klass)
    @@adt_types ||= []
  end

  def const(value = nil, &block)
    if value
      Rstruct.new(:value, __caller: caller, &block).new(value)
    else
      Rstruct.new(__caller: caller, &block).new
    end.tap do |k|
      @@adt_types << k
      def k.name
        self.class.name
      end
    end
  end

  def data(*fields, &block)
    Rstruct.new(*fields, __caller: caller, &block).tap { |k| @@adt_types << k.name }
  end
end

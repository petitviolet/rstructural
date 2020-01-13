# frozen_string_literal: true

require_relative '../rstruct'

module ADT
  def self.extended(klass)
    @@adt_types ||= []
  end

  def const(value = nil)
    if value
      Rstruct.new(:value, __caller: caller).new(value)
    else
      Rstruct.new(__caller: caller).new
    end.tap { |k| @@adt_types << k }
  end

  def data(*fields)
    Rstruct.new(*fields, __caller: caller).tap { |k| @@adt_types << k.name }
  end

  private

    def build_class_name(caller)
      names = caller.map do |stack|
        # ".../hoge.rb:7:in `<module:Hoge>'"
        if (m = stack.match(/\A.+in `<(module|class):(.+)>.+/))
          m[2]
        end
      end.reject(&:nil?)
      file_name, line_num = caller[0].split(':')
      line_executed = File.readlines(file_name)[line_num.to_i - 1]
      names << line_executed.match(/\A\s*(\S+)\s*=/)[1] # "  Point = Rstruct.new(:x, :y)\n"
      names.join('::')
    rescue StandardError
      'Enum'
    end

end

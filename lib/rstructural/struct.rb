# frozen_string_literal: true
#
module Rstructural
  module Struct
    def self.new(*attributes, __caller: nil, &block)
      begin
        kaller = __caller || caller
        names = kaller.map do |stack|
          # ".../hoge.rb:7:in `<module:Hoge>'"
          if (m = stack.match(/\A.+in `<(module|class):(.+)>.+/))
            m[2]
          end
        end.reject(&:nil?).reverse
        file_name, line_num = kaller[0].split(':')
        line_executed = File.readlines(file_name)[line_num.to_i - 1]
        names << line_executed.match(/\A\s*(\S+)\s*=/)[1] # "  Point = Struct.new(:x, :y)\n"
        class_name = names.join('::')
      rescue StandardError
        class_name = 'Struct'
      end
      Class.new.tap do |k|
        k.class_eval <<~RUBY
        def initialize(#{attributes.join(', ')})
          #{attributes.map { |attr| "@#{attr} = #{attr}" }.join("\n")}
        end

        #{attributes.map { |attr| "attr_reader(:#{attr})" }.join("\n")}

        def self.name
          "#{class_name}"
        end

        def self.to_s
          "<#{class_name}>"
        end

        def copy(#{attributes.map { |attr| "#{attr}: self.#{attr}"}.join(', ')})
          self.class.new(#{attributes.map { |attr| "#{attr}" }.join(', ')})
        end

        def [](key)
          _key = ("@" + key.to_s).to_sym
          self.instance_variable_get(_key)
        end

        def ==(other)
          return false if other.class != self.class
          #{attributes.empty? ? true : attributes.map { |attr| "other.#{attr} == self.#{attr}" }.join(" && ")}
        end

        def inspect
          if #{attributes.empty?}
            "#{class_name}"
          else
            __attrs = Array[#{attributes.map { |attr| "'#{attr}: ' + (@#{attr}.nil? ? 'nil' : @#{attr}.to_s)" }.join(', ')}].join(", ")
            "#{class_name}(" + __attrs + ")"
          end
        end

        alias :to_s :inspect

        def deconstruct
          [#{attributes.map { |attr| "@#{attr}" }.join(', ')}]
        end

        def deconstruct_keys(keys = nil)
          {#{attributes.map { |attr| "'#{attr}'.to_sym => @#{attr}" }.join(', ')}}
        end
        RUBY
        k.class_eval(&block) if block
      end
    end
  end
end


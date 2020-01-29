# Rstructural - Ruby structural types

[![rstructural](https://badge.fury.io/rb/rstructural.svg)](https://badge.fury.io/rb/rstructural)
[![Actions Status](https://github.com/petitviolet/rstructural/workflows/test/badge.svg)](https://github.com/petitviolet/rstructural/actions)

- Rstruct 
    - Struct implemented with Ruby
- Enum
    - A set of constants
- Algebraic Data Type(ADT)
    - A set of objects
    - A object is a constant or a set of objects

### Applied Types

- Option
    - Some or None
- Either
    - Left or Right

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rstructural'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rstructural

## Usage

### require

```ruby
require 'rstructural'
# Imported these types
# - Rstruct 
# - Enum 
# - ADT
```

or, require each modules with namespace `Rstructural`

```ruby
require 'rstructural/struct'
# - Rstructural::Struct 
require 'rstructural/enum'
# - Rstructural::Enum 
require 'rstructural/adt'
# - Rstructural::ADT
```

### Rstruct

```ruby
module RstructSample
  # define a struct type
  Value = Rstruct.new(:value)

  puts Value.name #=> 'RstructSample::Value'
  puts value = Value.new(100) #=> 'RstructSample::Value(value: 100)
  puts value == Value.new(100) #=> true
  puts value.value == 100 #=> true
  case value
    in Value[n] # pattern match (Ruby 2.7~)
    puts "here! value: #{n}" #=> 'here! value: 100'
  else
    raise
  end
end
```

### Enum

```ruby
module EnumSample
  # define enum
  module Status
    extend Enum

    # method(:enum) creates a enum value
    OK = enum 200
    NotFound = enum 404
    InternalServerError = enum 500 do
      # add block to define custom methods
      def message
        "Something wrong"
      end
    end
  end

  puts Status::OK #=> EnumSample::Status::OK(value: 200)
  puts Status::InternalServerError.message  #=> Something wrong

  # find enum by value
  case Status.of(404)
  in Status::NotFound
    puts "NotFound!!!" #=> NotFound!!!
  else
    raise
  end
end
```

### ADT

```ruby
module AdtSample
  # define ADT
  module Shape
    extend ADT

    # define a constant object
    Point = const

    # define a object with 1 attribute
    Circle = data :radius do |mod|
      def scale(i)
        Circle.new(radius * i)
      end
      def area
        3.14 * radius * radius
      end
    end
    # define a object with 2 attributes
    Rectangle = data :width, :height do |mod|
      def area
        width * height
      end
    end

    # define common interface
    interface do 
      def is_circle?
        case self
        in Circle 
          true 
        else
          false
        end
      end
    end
  end

  puts Shape::Point #=> AdtSample::Shape::Point
  puts Shape::Rectangle.new(3, 4) #=> AdtSample::Shape::Rectangle(width: 3, height: 4)
  puts Shape::Rectangle.new(3, 4).area #=> 12
  puts Shape::Circle.new(5).scale(2).area #=> 314.0
  puts Shape::Circle.is_circle? #=> true

  case Shape::Rectangle.new(1, 2)
  in Shape::Rectangle[Integer => i, Integer => j] if j % 2 == 0
    puts "here! rectangle #{i}, #{j}" #=> here! rectangle 1, 2
  else
    raise
  end
end
```

### Rstructural::Option

```ruby
puts Option.of(100).map { |v| v * 2 } #=> Option::Some(value: 200)
puts Option.of(nil).map { |v| v * 2 } #=> Option::None
puts Option.of(100).flat_map { |v| Option.of(v * 2) } #=> Option::Some(value: 200)
puts Option.of(100).flat_map { |v| v * 2 } #=> 200
puts Option.of(nil).flat_map { |v| Option.of(v * 2) } #=> Option::None
puts Option.of(100).get_or_else { 0 } #=> 100
puts Option.of(nil).get_or_else(0) #=> 0
puts Option.of(nil).get_or_else { 0 } #=> 0
puts Option.of(nil).is_a?(Option) #=> true
```

### Rstructural::Either

```ruby
puts Either.try { 100 } #=> Either::Right(value: 100)
puts Either.try { raise "this is error" } #=> Either::Left(value: this is error)
puts Either.try { raise "this is error" }.value.inspect #=> #<RuntimeError: this is error>
puts Either.right(100).map { |v| v * 2 } #=> Either::Right(value: 200)
puts Either.left(100).map { |v| v * 2 } #=> Either::Left(value: 100)
puts Either.left(100).map_left { |v| v * 2 } #=> Either::Left(value: 200)
puts Either.right(100).flat_map { |v| Either.right(v * 2) } #=> Either::Right(value: 200)
puts Either.right(100).flat_map { |v| Either.left(v * 2) } #=> Either::Left(value: 200)
puts Either.left(100).flat_map { |v| Either.right(v * 2) } #=> Either::Left(value: 100)
puts Either.left(100).flat_map_left { |v| Either.right(v * 2) } #=> Either::Right(value: 200)
puts Either.right(100).right_or_else { 0 } #=> 100
puts Either.left(100).right_or_else { 0 } #=> 0
puts Either.right(100).left_or_else { 0 } #=> 0
puts Either.left(100).left_or_else { 0 } #=> 100
puts Either.right(100).right? #=> true
puts Either.right(100).left? #=> false
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/petitviolet/rstruct. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/petitviolet/rstruct/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://petitviolet.mit-license.org/).

## Code of Conduct

Everyone interacting in the Rstruct project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/petitviolet/rstruct/blob/master/CODE_OF_CONDUCT.md).

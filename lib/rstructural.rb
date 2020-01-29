require_relative './rstructural/struct'
require_relative './rstructural/enum'
require_relative './rstructural/adt'
require_relative './rstructural/option'
require_relative './rstructural/either'

module Rstructural
end

# alias
Rstruct = Rstructural::Struct
Enum = Rstructural::Enum
ADT = Rstructural::ADT
Option = Rstructural::Option
Either = Rstructural::Either

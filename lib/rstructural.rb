require_relative './rstructural/struct'
require_relative './rstructural/enum'
require_relative './rstructural/adt'
require_relative './rstructural/option'

module Rstructural
end

# alias
Rstruct = Rstructural::Struct
Enum = Rstructural::Enum
ADT = Rstructural::ADT
Option = Rstructural::Option

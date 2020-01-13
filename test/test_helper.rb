$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "rstruct"
require_relative "../lib/rstruct/adt"
require_relative "../lib/rstruct/enum"

require "minitest/autorun"

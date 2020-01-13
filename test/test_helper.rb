$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "rstructural"
require_relative "../lib/rstructural/struct"
require_relative "../lib/rstructural/adt"
require_relative "../lib/rstructural/enum"

require "minitest/autorun"
require 'byebug'

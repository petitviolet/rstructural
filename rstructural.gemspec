Gem::Specification.new do |spec|
  spec.name          = "rstructural"
  spec.version       = "0.2.0"
  spec.authors       = ["petitviolet"]
  spec.email         = ["violethero0820@gmail.com"]

  spec.summary       = %q{A kind of structural types for Ruby}
  spec.description   = %q{Structural types, Struct, Enum and ADT for Ruby implemented with Ruby}
  spec.homepage      = "https://github.com/petitviolet/rstructural"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0") # using pattern match

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match("^(\.git*|sample|test|spec|features)") }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "byebug"
end

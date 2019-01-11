Gem::Specification.new do |spec|
  spec.name          = "logger"
  spec.version       = "1.2.7.1"
  spec.authors       = ["NAKAMURA, Hiroshi", "SHIBATA Hiroshi"]
  spec.email         = ["nahi@ruby-lang.org", "hsbt@ruby-lang.org"]

  spec.summary       = %q{Provides a simple logging utility for outputting messages.}
  spec.description   = %q{Provides a simple logging utility for outputting messages.}
  spec.homepage      = "https://github.com/ruby/logger"
  spec.license       = "BSD-2-Clause"

  spec.files         = ["lib/logger.rb", "test/logger/test_logger.rb"]
  spec.require_paths = ["lib"]
end

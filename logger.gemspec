version_module = Module.new do
  version_rb = File.join(__dir__, 'lib', 'logger', 'version.rb')
  version_rb = File.join(__dir__, 'version.rb') unless File.exist?(version_rb)
  module_eval(File.read(version_rb), version_rb)
end

Gem::Specification.new do |spec|
  spec.name          = "logger"
  spec.version       = version_module::Logger::VERSION
  spec.authors       = ["Naotoshi Seo", "SHIBATA Hiroshi"]
  spec.email         = ["sonots@gmail.com", "hsbt@ruby-lang.org"]

  spec.summary       = %q{Provides a simple logging utility for outputting messages.}
  spec.description   = %q{Provides a simple logging utility for outputting messages.}
  spec.homepage      = "https://github.com/ruby/logger"
  spec.licenses      = ["Ruby", "BSD-2-Clause"]

  spec.files         = Dir.glob("lib/**/*.rb") + ["logger.gemspec"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.3.0"

  spec.add_development_dependency "bundler", ">= 0"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "rdoc"
end

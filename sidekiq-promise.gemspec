# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq/promise/version'

Gem::Specification.new do |spec|
  spec.name          = "sidekiq-promise"
  spec.version       = Sidekiq::Promise::VERSION
  spec.authors       = ["James Harton"]
  spec.email         = ["james@resistor.io"]
  spec.summary       = %q{Wrap Sidekiq jobs in promises}
  spec.description   = %q{Treat Sidekiq jobs as asynchronous promises.}
  spec.homepage      = "https://github.com/jamesotron/sidekiq-promise"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  %w| rake rspec guard guard-rspec guard-bundler terminal-notifier-guard
      pry |.each do |gem|
    spec.add_development_dependency gem
  end

  spec.add_dependency 'sidekiq', '>= 3.0.1'
  spec.add_dependency 'mr_darcy', '>= 0.4.0'
end

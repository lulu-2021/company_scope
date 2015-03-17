# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'company_scope/version'

Gem::Specification.new do |spec|
  spec.name          = "company_scope"
  spec.version       = CompanyScope::VERSION
  spec.authors       = ["Steve Forkin"]
  spec.email         = ["steve.forkin@gmail.com"]

  spec.summary       = %q{A simple solution for Rails Multi Tenancy.}
  spec.description   = %q{A simple solution for Rails Multi Tenancy based on Active Record Default Scopes.}
  spec.homepage      = "http://github.com/netflakes/company_scope"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end
  #
  # Development dependencies
  #
  # - build related ones
  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  #
  # - gem related ones
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-given'
  spec.add_development_dependency 'rspec-collection_matchers'
  spec.add_development_dependency 'rails', '>= 4.1.1'
  spec.add_development_dependency 'request_store'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'database_cleaner', '>= 1.3.0'
  spec.add_development_dependency 'sqlite3'
  #
  # Runtime dependencies
  #
  spec.add_runtime_dependency 'rails', '>= 4.1.1'
  spec.add_runtime_dependency 'request_store'
  #
end

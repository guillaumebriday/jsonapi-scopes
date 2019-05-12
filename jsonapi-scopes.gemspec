# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'jsonapi/scopes/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'jsonapi-scopes'
  spec.version     = Jsonapi::Scopes::VERSION
  spec.authors     = ['Guillaume Briday']
  spec.email       = ['guillaumebriday@gmail.com']
  spec.homepage    = 'https://github.com/guillaumebriday/jsonapi-scopes'
  spec.summary     = 'This gem allows you to filter and sort an ActiveRecord relation based on a request, following the JSON:API specification as closely as possible.'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'rails'

  spec.add_development_dependency 'sqlite3'
end

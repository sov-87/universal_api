$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "universal_api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "universal_api"
  s.version     = UniversalApi::VERSION
  s.authors     = ["sov-87"]
  s.email       = ["afetisov87@gmail.com"]
  s.homepage    = "https://github.com/sov-87/universal_api"
  s.summary     = "UniversalApi gives REST interface for accessing ActiveRecord models"
  s.description = "UniversalApi gives REST interface for accessing ActiveRecord models"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_development_dependency "sqlite3"
  s.add_dependency "will_paginate"
  s.add_dependency "ransack"
end

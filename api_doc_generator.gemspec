$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "api_doc_generator/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "api_doc_generator"
  s.version     = ApiDocGenerator::VERSION
  s.authors     = ["d.e.savelev"]
  s.email       = ["d.e.saveliev@gmail.com"]
  s.homepage    = "https://github.com/dsaveliev/api_doc_generator"
  s.summary     = "Doc generator from json schema"
  s.description = "Doc generator form json schema"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.7.1"
  s.add_dependency "bootstrap-sass"
  s.add_dependency "redcarpet", "~> 3.2.0"
  s.add_dependency 'slim-rails'
  s.add_dependency 'slim'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'json-schema'

  s.add_development_dependency 'sqlite3'

end

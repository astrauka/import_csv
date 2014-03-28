$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "csv_import/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "csv_import"
  s.version     = CsvImport::VERSION
  s.authors     = ["Bit Zesty"]
  s.email       = ["info@bitzesty.com"]
  s.homepage    = "http://bitzesty.com/"
  s.summary     = "Provides structure for importing bigger data sets via CSV. Supports importing via background job as well."
  s.description = "Provides structure for importing bigger data sets via CSV. Supports importing via background job as well."
  s.license     = 'MIT'

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_development_dependency "rails", "~> 4.0.4"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "capybara"
  s.add_development_dependency "poltergeist"
end

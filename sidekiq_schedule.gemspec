$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sidekiq_schedule/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name          = "sidekiq_schedule"
  s.version       = SidekiqSchedule::VERSION
  s.authors       = ["Meinhard Gredig"]
  s.email         = ["mg@flexcoding.de"]
  s.homepage      = "http://www.flexcoding.de"
  s.summary       = "Addition for sidekiq to support scheduled jobs"
  s.description   = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", '4.0.6'
  s.add_dependency "protected_attributes"
  s.add_dependency "cron2english"
  s.add_dependency "parse-cron"

  s.add_development_dependency "sqlite3"
end

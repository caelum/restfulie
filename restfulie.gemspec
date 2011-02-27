# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "restfulie/version"

Gem::Specification.new do |s|
	s.name        = "restfulie"
	s.version     = Restfulie::VERSION
	s.platform    = Gem::Platform::RUBY
	s.authors     = ["Guilherme Silveira, Caue Guerra, Luis Cipriani, Everton Ribeiro, George Guimaraes, Paulo Ahagon, and many more!"]
	s.email       = %q{guilherme.silveira@caelum.com.br}
	s.homepage    = %q{http://restfulie.caelumobjects.com}
	s.summary     = %q{Hypermedia aware resource based library in ruby (client side) and ruby on rails (server side).}
	s.description = %q{restfulie}

	s.rubyforge_project = "restfulie"

	s.files         = `git ls-files`.split("\n")
	s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
	s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
	s.require_paths = ["lib"]

	if s.respond_to? :specification_version then
		current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
		s.specification_version = 3
	end

  if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    s.add_runtime_dependency("nokogiri", [">= 1.4.2"])
    s.add_runtime_dependency("json_pure", [">= 1.2.4"])
    s.add_development_dependency("sqlite3-ruby")
  else
    s.add_dependency("nokogiri", [">= 1.4.2"])
    s.add_dependency("json_pure", [">= 1.2.4"])
    s.add_dependency("sqlite3-ruby")
  end

  s.add_dependency("rack-conneg")
  s.add_dependency("sqlite3-ruby")
  s.add_dependency('tokamak', "~> 1.2.0")
  s.add_dependency('medie', "~> 1.0.0")
  s.add_dependency('respondie', "~> 0.9.0")
end

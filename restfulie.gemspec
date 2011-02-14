# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{restfulie}
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Guilherme Silveira, Caue Guerra, Luis Cipriani, Everton Ribeiro, George Guimaraes, Paulo Ahagon, and many more!"]
  s.date = %q{2011-01-06}
  s.email = %q{guilherme.silveira@caelum.com.br}
	s.files = Dir["{lib}/**/*.rb", "Gemfile", "LICENSE"]
	s.files.reject!  { |file| file =~ %r{^(fake)/} }
  
  s.homepage = %q{http://restfulie.caelumobjects.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.4.1}
  s.summary = %q{Hypermedia aware resource based library in ruby (client side) and ruby on rails (server side).}
  
  s.add_dependency("rack-conneg")
  s.add_dependency('tokamak', "~> 1.1.2")
  s.add_dependency('medie', "~> 1.0.0")
  s.add_dependency('respondie', "~> 0.9.0")
    
  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.4.2"])
      s.add_runtime_dependency(%q<json_pure>, [">= 1.2.4"])
      s.add_development_dependency("sqlite3-ruby")
    else
      s.add_dependency(%q<nokogiri>, [">= 1.4.2"])
      s.add_dependency(%q<json_pure>, [">= 1.2.4"])
      s.add_dependency("sqlite3-ruby")
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 1.4.2"])
    s.add_dependency(%q<json_pure>, [">= 1.2.4"])
    s.add_dependency("sqlite3-ruby")
  end
end

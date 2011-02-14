require 'rubygems'
require 'rubygems/specification'
require 'rake'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rspec'
require 'rspec/core'
require 'rspec/core/rake_task'
require File.join(File.dirname(__FILE__), 'lib', 'restfulie', 'version')

GEM = "restfulie"
GEM_VERSION = Restfulie::VERSION
SUMMARY  = "Hypermedia aware resource based library in ruby (client side) and ruby on rails (server side)."
AUTHOR   = "Guilherme Silveira, Caue Guerra, Luis Cipriani, Everton Ribeiro, George Guimaraes, Paulo Ahagon, and many more!"
EMAIL    = "guilherme.silveira@caelum.com.br"
HOMEPAGE = "http://restfulie.caelumobjects.com"

spec = Gem::Specification.new do |s|
	s.description = "restfulie"
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = SUMMARY
  s.require_paths = ['lib']
  s.files = FileList['lib/**/*.rb', '[A-Z]*', 'lib/**/*.rng'].to_a
  
  s.add_dependency("nokogiri", [">= 1.4.2"])
  s.add_dependency("json_pure", [">= 1.2.4"])
  s.add_dependency("rack-conneg")
  s.add_dependency("sqlite3-ruby")
  s.add_dependency('tokamak', "~> 1.1.2")
  s.add_dependency('medie', "~> 1.0.0")
  s.add_dependency('respondie', "~> 0.9.0")
  

  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
end

module FakeServer
  def self.wait_server(port=3000)
    (1..15).each do 
      begin
        Net::HTTP.get(URI.parse("http://localhost:#{port}/"))
        return
      rescue
        sleep 1
      end
    end
    raise "Waited for the server but it did not finish"
  end
  
  def self.start_sinatra
    IO.popen("cd tests && ruby ./spec/requests/fake_server.rb") do |pipe|
      wait_server 4567
      yield
      Process.kill 'INT', pipe.pid
    end
  end
  
  def self.run(setup, process)
    success = IO.popen(setup) do |pipe|
      wait_server
      success = system "rake spec"
      Process.kill 'INT', pipe.pid
      success
    end
    if !success
      raise "Some of the specs failed"
    end
  end
  
  def self.start_server_and_run_spec(target_dir)
    success = Dir.chdir(File.join(File.dirname(__FILE__), target_dir)) do
      system('bundle install')
      system('rake db:drop db:create db:migrate')
      self.run "rails server", "rake spec"
    end
  end
  
end

# optionally loads a task if the required gems exist
def optionally
  begin
    yield
  rescue LoadError; end
end

namespace :test do
  
  task :spec do
    FakeServer.start_sinatra do
      FakeServer.start_server_and_run_spec "tests"
    end
  end
  
  task :integration do
    FakeServer.start_server_and_run_spec "full-examples/rest_from_scratch/part_1"
    FakeServer.start_server_and_run_spec "full-examples/rest_from_scratch/part_2"
    FakeServer.start_server_and_run_spec "full-examples/rest_from_scratch/part_3"
  end
  
  task :sinatra do
    FakeServer.start_sinatra do
      puts "Press something to quit"
      gets
    end
  end
  
  task :all => ["spec","integration"]
  
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['--colour', '--format progress']
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

Rake::RDocTask.new("rdoc") do |rdoc|
   rdoc.options << '--line-numbers' << '--inline-source'
end

optionally do
  require 'yard'
  YARD::Rake::YardocTask.new do |t|
    t.files   = ['lib/restfulie/**/*.rb', 'README.textile']
  end
end

desc "Install the gem locally"
task :install => [:package] do
  sh %{gem install pkg/#{GEM}-#{GEM_VERSION}.gem -l}
end

desc "Create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

desc "Runs everything"
task :all => ["install", "test:spec"]

desc "Default build will run specs"
task :default => :all


# encoding: UTF-8

require 'rubygems'
require 'rubygems/specification'
require 'rake'
require 'rake/gempackagetask'
require 'spec/rake/spectask'
require 'rake/rdoctask'
require File.expand_path('lib/restfulie')

GEM = "restfulie"
GEM_VERSION = Restfulie::VERSION
SUMMARY  = "Hypermedia aware resource based library in ruby (client side) and ruby on rails (server side)."
AUTHOR   = "Guilherme Silveira, Caue Guerra, Luis Cipriani, Everton Ribeiro, George Guimaraes, Paulo Ahagon"
EMAIL    = "guilherme.silveira@caelum.com.br"
HOMEPAGE = "http://restfulie.caelumobjects.com"

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = SUMMARY
  s.require_paths = ['lib']
  s.files = FileList['lib/**/*.rb', '[A-Z]*', 'lib/**/*.rng'].to_a
  s.add_dependency("nokogiri", [">= 1.4.2"])
  s.add_dependency("actionpack", [">= 2.3.2"])
  s.add_dependency("activesupport", [">= 2.3.2"])
  s.add_dependency("responders_backport", ["~> 0.1.0"])
  s.add_dependency("json_pure", [">= 1.2.4"])

  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
end

# optionally loads a task if the required gems exist
def optionally
  begin
    yield
  rescue LoadError; end
end

def execute_process(name)
  sh "ruby ./spec/units/client/#{name}.rb &"
  sleep 15
  %x(ps -ef | grep #{name}).split[1]  
end

def process(name)
  %x(ps -ef | grep #{name} | grep -v grep).split[1] || execute_process(name)
end

def start_server_and_invoke_test(task_name)
  pid = process "fake_server"
  puts "fake_server pid >>>> #{pid}"
  Rake::Task[task_name].invoke
  sh "kill -9 #{pid}"
end

def kill_server
  c = `(ps -ef | grep 'script/server')`.split(/\n/)
  c.each do |line|
    pid = line.split[1]
    system "kill -9 #{pid}"
  end
end

def wait_server
  15.times do 
    begin
      Net::HTTP.get(URI.parse('http://localhost:3000/'))
      return
    rescue
      sleep 1
    end
  end
end

desc 'Start server'
task :server do
  process 'fake_server' 
end

namespace :test do
  
  desc "Execute integration Order tests"
  task :integration do
    integration_path = "spec/integration/order/server"

    Dir.chdir(File.join(File.dirname(__FILE__), integration_path)) do
      system('rake db:drop db:create db:migrate')
      system('rake')
    end
  end
  
  namespace :spec do
    spec_opts = ['--options', File.join(File.dirname(__FILE__) , 'spec', 'units', 'spec.opts')]
    Spec::Rake::SpecTask.new(:all) do |t|
      t.spec_files = FileList['spec/units/**/*_spec.rb']
      t.spec_opts = spec_opts
    end
    Spec::Rake::SpecTask.new(:common) do |t|
      t.spec_files = FileList['spec/common/**/*_spec.rb']
      t.spec_opts = spec_opts
    end
    Spec::Rake::SpecTask.new(:client) do |t|
      t.spec_files = FileList['spec/units/client/**/*_spec.rb']
      t.spec_opts = spec_opts
    end
    Spec::Rake::SpecTask.new(:server) do |t|
      t.spec_files = FileList['spec/units/server/**/*_spec.rb']
      t.spec_opts = spec_opts
    end
  end
  
  namespace :rcov do
    Spec::Rake::SpecTask.new('rcov') do |t|
      options_file = File.expand_path('spec/units/spec.opts')
      t.spec_opts = %w(-fs -fh:doc/specs.html --color)
      t.spec_files = FileList['spec/units/**/*_spec.rb']
      t.rcov = true
      t.rcov_opts = ["-e", "/Library*", "-e", "~/.rvm", "-e", "spec", "-i", "bin"]
    end
    desc 'Run coverage test with fake server'
    task :run do
      start_server_and_invoke_test('test:rcov:rcov')
    end
  end
  
  namespace :run do
    task :all do
      start_server_and_invoke_test('test:spec:all')
      puts "Execution integration tests... (task test:integration)"
      Rake::Task["test:integration"].invoke()
    end
    task :common do
      start_server_and_invoke_test('test:spec:common')
    end
    task :client do
      start_server_and_invoke_test('test:spec:client')
    end
    task :server do
      start_server_and_invoke_test('test:spec:server')
    end
    task :rcov do
      start_server_and_invoke_test('test:rcov:rcov')
    end
  end

  desc "runs all example tests"
  task :examples do
    kill_server
    enter_dir = "cd full-examples/rest_from_scratch/part_3"
    system "#{enter_dir} && RAILS_ENV=test rake db:reset db:seed"
    system "#{enter_dir} && RAILS_ENV=test script/server &"
    wait_server
    system "sleep 5 && curl http://localhost:3000/items"
    system "#{enter_dir} && rake spec"
    kill_server
  end

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
  sh %{gem install pkg/#{GEM}-#{GEM_VERSION} -l}
end

desc "Create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

desc "Builds the project"
task :build => :spec

desc "Default build will run specs"
task :default => ['test:run:all']

